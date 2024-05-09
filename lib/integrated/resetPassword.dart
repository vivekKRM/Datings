import 'dart:convert';
import 'package:Dating/constants/styles.dart';
import 'package:Dating/integrated/dashboardScreen.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key, required this.title, required this.appManager})
      : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool incorrectCreds = false;
  String password = '';
  String username = '';
  bool obscureText = true;
  bool obscureText1 = true;
  bool obscureText2 = true;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newcPasswordController = TextEditingController();
  late SharedPreferences prefs;
  bool loginError = false;
  late FToast fToast;

  Future<void> resetPassword() async {
    if (username != "") {
      final requestBody = {
        "username": username,
        "password": newPasswordController.text,
        "oldPassword": oldPasswordController.text
      };
      widget.appManager.apis
          .resetPassword(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) {
        // Handle successful response
        if (response.status == 200) {
          showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          _showCustomDialog(context);
        } else if (response.status == 201) {
          showToast(response?.message ?? '', 2, kToastColor, context);
         } else if (response?.status == 502) {
          showLogoutDialog(BuildContext context) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LogoutAlert(
                  title: 'Active/Inactive Status',
                  subtitle: response?.message ?? '',
                  islogout: false,
                  logoutAction: () async {
                    await widget.appManager.clearLoggedIn();
                    if (widget.appManager.islogout == true) {
                      widget.appManager.utils.isPatientExitDialogShown = false;
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/obs', (route) => false);
                    }
                  },
                );
              },
            );
          }
        } else {
          print("Failed to reset password");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to reset password: $error");
      });
    } else {
      showToast('not getting username', 2, kToastColor, context);
    }
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 310,
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/congrats.gif', // Replace 'assets/animation.gif' with the path to your GIF file
                  width: 80, // Adjust the width as needed
                  height: 80, // Adjust the height as needed
                ),
                SizedBox(height: 10),
                Text(
                    textAlign: TextAlign.center,
                    'Congratulations',
                    style: kCongratsTextStyle),
                SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  "Password has been reset successfully.",
                  style: kObsText,
                ),
                SizedBox(height: 34),
                Container(
                  width: size.width,
                  height: 65,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: kButtonColor,
                    ),
                    child: Text('OK', style: kButtonTextStyle),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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

  bool isValidEmailAndPassword() {
    // Email regex pattern
    final emailPattern = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (oldPasswordController.text == '' &&
        oldPasswordController.text.length < 6) {
      showToast('Please enter old password', 2, kToastColor, context);
      return false;
    }else if (oldPasswordController.text.contains(' ')){
       showToast('Old password cannot contain spaces', 2, kToastColor, context);
       return false;
    } else if (newPasswordController.text == '' &&
        newPasswordController.text.length < 6) {
      showToast('Please enter new password', 2, kToastColor, context);
      return false;
    }else if (newPasswordController.text.contains(' ')){
       showToast('New password cannot contain spaces', 2, kToastColor, context);
       return false;
    } else if (newcPasswordController.text.length < 6 &&
        newcPasswordController.text == '') {
      showToast('Please enter confirm password', 2, kToastColor, context);
      return false;
    }else if (newcPasswordController.text.contains(' ')){
       showToast('New confirm password cannot contain spaces', 2, kToastColor, context);
       return false;
    } else if (newcPasswordController.text != newPasswordController.text) {
      showToast('new password and confirm password doesnot match', 2,
          kToastColor, context);
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
    getPrefs();
    // this.jumpToHomeIfRequired();
  }

  getPrefs() async {
    this.prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username') ?? '';
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
          backgroundColor: kAppBarColor,
          surfaceTintColor: kAppBarColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '',
            style: kHeaderTextStyle,
          ),
        ),
        body: Container(
          color: kBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              // physics: NeverScrollableScrollPhysics(),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon.png',
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 42),
                    Text('Reset Password?', style: kLoginTextStyle),
                    SizedBox(height: 20),
                    Text(
                      "Your new password must be different from previous used passwords",
                      style: kObsText,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 42),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      margin: EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kLoginTextFieldFillColor,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_open_outlined,
                              size: 20, color: kLoginIconColor),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: oldPasswordController,
                              obscureText: obscureText,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: 'Old Password',
                                hintStyle: kLoginTextFieldTextStyle,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 15,),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      margin: EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kLoginTextFieldFillColor,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_open_outlined,
                              size: 20, color: kLoginIconColor),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: newPasswordController,
                              obscureText: obscureText1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: 'New Password',
                                hintStyle: kLoginTextFieldTextStyle,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureText1 = !obscureText1;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Icon(
                                obscureText1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 15,),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      margin: EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kLoginTextFieldFillColor,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_open_outlined,
                              size: 20, color: kLoginIconColor),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: newcPasswordController,
                              obscureText: obscureText2,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: 'Confirm Password',
                                hintStyle: kLoginTextFieldTextStyle,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureText2 = !obscureText2;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Icon(
                                obscureText2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                          ),
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
                        child: Text('Reset Password', style: kButtonTextStyle),
                        onPressed: () {
                          if (isValidEmailAndPassword()) {
                            resetPassword();
                          }
                        },
                      ),
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
