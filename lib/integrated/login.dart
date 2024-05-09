import 'package:Dating/constants/styles.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Login extends StatefulWidget {
  Login({Key? key, required this.title, required this.appManager})
      : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = '';
  late SharedPreferences prefs;
  String password = '';
  bool obscureText = true;
  bool _loading = false;
  bool loginn = false;
  late FToast fToast;
  Map _userObj = {};

  void login() {
    setState(() {
      _loading = true;
    });
    widget.appManager.login(email, password).then(((response) async {
      if (response?.status == 200) {
        setState(() {
          _loading = false;
        });
        prefs.setString('email', email);
        prefs.setString('password', password);
        prefs.setString('username', response?.user?.user ?? '');
        prefs.setString('sId', response?.user?.id ?? '');
        prefs.setString('authToken', response?.token ?? '');
        await widget.appManager.markLoggedIn(response?.token ?? '');
        await widget.appManager.initSocket(response?.token ?? '');
        var loggedIn = await widget.appManager.hasLoggedIn();
        if (loggedIn['hasLoggedIn']) {
          Navigator.pushReplacementNamed(context, '/home', arguments: false);
        }
      } else if (response?.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor);
        setState(() {
          _loading = false;
        });
      } else if (response?.status == 502) {
        setState(() {
          _loading = false;
        });
        showToast(response?.message ?? '', 2, kToastColor);
        await this.widget.appManager.clearLoggedIn();
        if (this.widget.appManager.islogout == true) {
          this.widget.appManager.utils.isPatientExitDialogShown = false;
          Navigator.pushNamedAndRemoveUntil(context, '/obs', (route) => false);
        }
      } else {
        setState(() {
          _loading = false;
        });
        showToast(response?.message ?? '', 2, kToastColor);
      }
    }));
  }

  void forgetPassword() {
    Navigator.pushNamed(context, "/forgetPassword");
  }

  void showToast(String msg, int duration, Color bgColor) {
    Widget toast = Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Container(
          width: msg.length * 10.0,
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

  bool isValidEmailAndPassword(String email, String password) {
    // Email regex pattern
    final emailPattern = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (emailController.text == '') {
      Fluttertoast.showToast(
        msg: 'please enter valid username, please try again',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: kToastColor,
      );
      return false;
    } else if (password.contains(' ')) {
      Fluttertoast.showToast(
        msg: 'Password cannot contain spaces',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: kToastColor,
      );
      return false;
    } else if (password.length < 6) {
      Fluttertoast.showToast(
        msg: 'please enter valid password, please try again',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: kToastColor,
      );
      return false;
    } else {
      return true;
    }
  }

  _launchURL(String urlhit) async {
    if (await canLaunch(urlhit)) {
      await launch(urlhit);
    } else {
      throw 'Could not launch $urlhit';
    }
  }

  Future<void> loginWithFacebook() async {
    FacebookAuth.instance
        .login(permissions: ['public_profile', 'email']).then((value) {
      FacebookAuth.instance.getUserData().then((userData) async {
        setState(() {
          loginn = true;
          _userObj = userData;
          print(_userObj['name'] + _userObj['email']);
        });
      });
    });
  }

  Future<void> logoutWithFacebook() async {
    FacebookAuth.instance.logOut().then((value) {
      setState(() {
        loginn = false;
        _userObj = {};
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
    fToast = FToast();
    fToast.init(context);
  }

  getPrefs() async {
    this.prefs = await SharedPreferences.getInstance();
    // prefs.setString('email', profile.response?.email  ?? '');
    this.email = prefs.getString('email') ?? '';
    this.password = prefs.getString('password') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 1.0,
        backgroundColor: topHeaderBar, //kAppBarColor
        surfaceTintColor: topHeaderBar, //kAppBarColor
      ),
      body: Container(
        color: kBackgroundColor,
        child: ListView(
          // physics: NeverScrollableScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width,
                  height: 220,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: Image.asset(
                      'assets/ship.gif',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text('Log In', style: kLoginTextStyle),
                      const SizedBox(height: 25),
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
                            Icon(Icons.person_2_outlined,
                                size: 20, color: kLoginIconColor),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  // contentPadding:
                                  //     EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                                  isDense: true,
                                  hintText: 'Username',
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
                      SizedBox(height: 10),
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
                                controller: passwordController,
                                obscureText: obscureText,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  // contentPadding:
                                  //     EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                                  isDense: true,
                                  hintText: 'Password',
                                  hintStyle: kLoginTextFieldTextStyle,
                                ),
                                onChanged: (value) {
                                  this.setState(() {
                                    password = value;
                                  });
                                },
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
                      Container(
                        width: size.width,
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            this.forgetPassword();
                          },
                          child: Text('Forgot Password?',
                              style: kForgotPasswordTextStyle),
                        ),
                      ),
                      SizedBox(height: 26),
                      _loading
                          ? CircularProgressIndicator()
                          : Container(
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
                                child: Text('Log In', style: kButtonTextStyle),
                                onPressed: () {
                                  if (isValidEmailAndPassword(
                                      email, password)) {
                                    login();
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
                                this.forgetPassword();
                              },
                              child: Text("Don't have an account? ",
                                  style: kForgotPasswordTextStyle),
                            ),
                          ),
                          Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "/personal");
                                //  Navigator.pushNamed(context, "/passport", arguments:  false);
                              },
                              child: Text("Sign Up ", style: kSignUpTextStyle),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle click for first icon
                              print('Instagram icon clicked');
                              _launchURL('https://www.instagram.com/');
                            },
                            child: Image.asset(
                              'assets/instagram.png',
                              height: 55,
                              width: 55,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle click for second icon
                              print('Facebook icon clicked');
                              // _launchURL('https://www.facebook.com/');
                              loginWithFacebook();
                            },
                            child: Image.asset(
                              'assets/facebook.png',
                              height: 50,
                              width: 50,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle click for third icon
                              print('Twitter icon clicked');
                              _launchURL('https://twitter.com/');
                            },
                            child: Image.asset(
                              'assets/twitter.png',
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
