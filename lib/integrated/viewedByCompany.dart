import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getCompany.dart';
import 'package:Dating/json/getRank.dart';
import 'package:Dating/json/getShip.dart';
import 'package:Dating/json/jobSearch.dart';
import 'package:Dating/json/viewedCompany.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewedByCompany extends StatefulWidget {
  ViewedByCompany({
    Key? key,
    required this.title,
    required this.appManager,
  }) : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _ViewedByCompanyState createState() => _ViewedByCompanyState();
}

class _ViewedByCompanyState extends State<ViewedByCompany> {
  late FToast fToast;
  String token = '';
  String user_id = '';
  String comp_id = '';
  late SharedPreferences prefs;
  List<Result?> companieslist = [];

  Future<void> getviewedCompanyList() async {
    if (user_id != "") {
      final requestBody = {
        'user_id': user_id,
      };
      widget.appManager.apis
          .getViewedCompany(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // prefs.setString('sId', response?.user?.id ?? '');
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            companieslist = response?.user ?? [];
          });
        } else if (response?.status == 201) {
          showToast(response?.message ?? '', 2, kToastColor, context);
        } else if (response?.status == 502) {
          await widget.appManager.clearLoggedIn();
          if (widget.appManager.islogout == true) {
            widget.appManager.utils.isPatientExitDialogShown = false;
            Navigator.pushNamedAndRemoveUntil(
                context, '/obs', (route) => false);
          }
        } else {
          print("Failed to get viewed company list data");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to get viewed company list data: $error");
      });
    } else {
      showToast('Please get user_id', 2, kToastColor, context);
    }
  }

  void showToast(
      String msg, int duration, Color bgColor, BuildContext context) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // this.jumpToHomeIfRequired();
    getPrefs();
    fToast = FToast();
    fToast.init(context);
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('authToken') ?? '';
    user_id = prefs.getString('sId') ?? '';
    getviewedCompanyList();
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
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: kAppBarColor,
          surfaceTintColor: kAppBarColor,
          title: Text(
            'Viewed By Company',
            style: kHeaderTextStyle,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: kAppBarColor,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: companieslist.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 12),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFECEDF5),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            '${index + 1}.  ',
                                            style: kHeaderTextStyle,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${companieslist[index]?.companyname ?? ''}',
                                              style: kDropDownTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    height: size.height * 0.85,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
