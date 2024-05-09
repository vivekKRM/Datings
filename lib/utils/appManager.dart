import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/login-json.dart';
import 'package:Dating/utils/apis.dart';
import 'package:Dating/utils/general.dart';
import 'package:Dating/utils/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:simple_moment/simple_moment.dart';

var ipSettings = {
  'd-laptop': '192.168.0.102',
  'd-desktop': '172.20.10.3',
  'd-apple': '192.168.1.66',
  'san-laptop': '192.168.43.23' //added changes
};
var me = 'd-apple';

class AppManager {
  late http.Client client;
  String serverURL = 'https://bizhawkztest.com/seajobs/api';
  late IO.Socket socket;
  late Apis apis;
  late General utils;
  late Notifications notifications;
  bool appOpenedByNotification = false;
  bool islogout = false;
  late String currentPage;
  late Widget currentPageObject;
  late SharedPreferences prefs;
  AppManager(String mode, SharedPreferences prefs) {
    this.apis = new Apis(this);
    this.utils = new General(this);
    // this.notifications = new Notifications(this);
    this.prefs = prefs;
    // this._initialization = Firebase.initializeApp();
    Moment.setLocaleGlobally(new LocaleEn());
  }
  log(name, message) {
    developer.log(message, name: name);
    print('$name: $message');
  }

  Future<Map<String, dynamic>> hasLoggedIn() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasLoggedIn = prefs.getBool('hasLoggedIn') ?? false;
    String authToken = prefs.getString('authToken') ?? '';
    print('hasLoggedIn $hasLoggedIn $authToken');
    return {'hasLoggedIn': hasLoggedIn, 'authToken': authToken};
  }

  markLoggedIn(String authToken) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasLoggedIn', true);
    prefs.setString('authToken', authToken);
  }

  clearLoggedIn() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('hasLoggedIn');
    prefs.remove('authToken');
    prefs.remove('sId');
    prefs.clear();
    print("Clear Login");
    islogout = true;
  }

  Future<LoginResponse?> login(email, password) async {
    email = email ?? "";
    password = password ?? "";
    if (email != "" && password != "") {
      var client = http.Client();
      try {
        print("sending request to $serverURL/api/login\n\"$email\"\n$password");
        var uriResponse = await client.post(Uri.parse('$serverURL/login'),
            body: {'username': email.trim().toLowerCase(), 'password': password});
        this.log('app.auth', 'uriResponse ${uriResponse.body}');
        if (uriResponse.body != null) {
          Map<String, dynamic> respMap = jsonDecode(uriResponse.body);
          var user = LoginResponse.fromJson(respMap);
          return user;
        }
      } finally {
        client.close();
      }
    }
    return null;
  }

  

  // Future<LoginResponse?> changePassword(
  //     String password, bool forgotPasswordMode) async {
  //   var client = http.Client();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   print("prefs.getString('email') ${prefs.getString('email')}");
  //   print("prefs.getString('email') ${prefs.getString('oldPassword')}");
  //   print("prefs.getString('email') ${prefs.getString('sId')}");
  //   print("prefs.getString('email') ${prefs.getString('hospital')}");
  //   try {
  //     var uriResponse =
  //         await client.post(Uri.parse('$serverURL/api/changePassword'), body: {
  //       'email': prefs.getString('email'),
  //       'newPassword': password,
  //       'oldPassword': prefs.getString('oldPassword'),
  //       "id": prefs.getString('sId'),
  //       "hospital": prefs.getString('hospital'),
  //       "forgotPasswordMode": '$forgotPasswordMode'
  //     });
  //     print("change pasword $password $forgotPasswordMode");
  //     this.log('app.auth', 'uriResponse ${uriResponse.body}');
  //     if (uriResponse.body != null) {
  //       Map<String, dynamic> respMap = jsonDecode(uriResponse.body);
  //       var user = LoginResponse.fromJson(respMap);
  //       if (user?.result?.msg != null) {
  //         Fluttertoast.showToast(
  //           msg: user?.result?.msg ?? '',
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.TOP,
  //           backgroundColor: kToastColor,
  //         );
  //       } else {
  //         prefs.remove('oldPassword');
  //       }
  //       return user;
  //     }
  //   } finally {
  //     client.close();
  //   }
  //   return null;
  // }

  initSocket(String authToken) async {
    socket = IO.io(
        serverURL,
        kIsWeb
            ? <String, dynamic>{
                'transportOptions': {
                  'polling': {
                    'extraHeaders': {'authToken': authToken}
                  }
                }
              }
            : <String, dynamic>{
                'transports': ['websocket'],
                'extraHeaders': {'authToken': authToken}
              });
    socket.on('connect', (_) async {
      print('connected');
    });
    socket.on('event', (data) => print(data));
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  Future<dynamic> postFile(
      String url, Map<String, dynamic> fields, File file) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));

    List<String> extraFields = fields.keys.toList();
    for (int i = 0; i < extraFields.length; i++) {
      request.fields[extraFields[i]] = fields[extraFields[i]];
    }
    // request.fields['authToken'] =
    //     (await SharedPreferences.getInstance()).getString('authToken');
    request.headers['authToken'] =
        (await SharedPreferences.getInstance()).getString('authToken') ?? '';
    var pic =
        await http.MultipartFile("file", file.openRead(), await file.length());
    request.files.add(pic);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    return responseString;
  }

  Future<dynamic> send(String endpoint, dynamic data) async {
    String reqId = 'r_${Random.secure().nextInt(9999999)}';
    print('sending request to $reqId $endpoint $data');
    // socket.emit(endpoint, {reqId: reqId, data: data});
    socket.emit(endpoint, '{"reqId": "$reqId", "data":${json.encode(data)}}');
    final Completer<dynamic> completer = Completer();
    socket.once('$endpoint:$reqId:reply', (data) => {completer.complete(data)});
    socket.once(
        '$endpoint:$reqId:error', (data) => {completer.completeError(data)});
    return completer.future;
  }
}