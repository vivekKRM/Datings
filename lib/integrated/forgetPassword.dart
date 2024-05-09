import 'dart:convert';
import 'package:Dating/constants/styles.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({Key? key, required this.title, required this.appManager})
      : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool incorrectCreds = false;
  String email = '';
  String password = '';
  TextEditingController emailController = TextEditingController();
  late SharedPreferences prefs;
  bool loginError = false;
  late FToast fToast;

  Future<void> forgetPassword(String email) async {
    if (email != "") {
      prefs.setString('email', email);
      final requestBody = {"email": email};
      widget.appManager.apis
          .sendPostRequest(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) {
        // Handle successful response
        if (response.status == 200) {
          showToast(response?.message ?? '', 2, kPositiveToastColor);
          Navigator.pushReplacementNamed(context, '/login');
        } else if (response.status == 201) {
          showToast(response?.message ?? '', 2, kToastColor);
        } else {
          print("Failed to forgot password");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to forgot password: $error");
      });
    } else {
      showToast('Please enter email', 2, kToastColor);
    }
  }

  void showToast(String msg, int duration, Color bgColor) {
    Widget toast = Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Container(
          width: msg.length * 8.0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: bgColor,
          ),
          child: Text(
            msg,
            style: kToastTextStyle,
            maxLines: 5,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: duration),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 100.0,
          );
        });
  }

  bool isValidEmailAndPassword(String email) {
    // Email regex pattern
    final emailPattern = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!(emailPattern.hasMatch(email))) {
      Fluttertoast.showToast(
        msg: 'please enter valid email address, please try again',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: kToastColor,
      );
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    getPrefs(email);
    // this.jumpToHomeIfRequired();
  }

  getPrefs(String email) async {
    this.prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '';
    // emailController.text = email;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // Disable back button
        return false;
      },
      child: Scaffold(
        body: Container(
          color: kBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              // physics: NeverScrollableScrollPhysics(),
              children: [
                IconButton(
                  alignment: Alignment.topLeft,
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon.png',
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 42),
                    Text('Forgot Password?', style: kLoginTextStyle),
                    SizedBox(height: 20),
                    Text(
                      "Please enter email associated with your Dating app account and we'll send an email with new password.",
                      style: kObsText,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 42),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kLoginTextFieldFillColor,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.email_outlined,
                              size: 20, color: kLoginIconColor),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                // contentPadding:
                                //     EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                                isDense: true,
                                hintText: 'Email address',
                                hintStyle: kLoginTextFieldTextStyle,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                              onSaved: (String? value) {
                                // Handle onSaved if needed
                              },
                              validator: (String? value) {
                                // Add validation logic if needed
                                return null;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 26),
                    Container(
                      width: size.width,
                      height: 65,
                      // margin: EdgeInsets.only(bottom: 30),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: kButtonColor,
                        ),
                        child: Text('Send', style: kButtonTextStyle),
                        onPressed: () {
                          if (isValidEmailAndPassword(email)) {
                            forgetPassword(email);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text("Already have an account? ",
                                style: kForgotPasswordTextStyle),
                          ),
                        ),
                        Container(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text("Log In ", style: kSignUpTextStyle),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
