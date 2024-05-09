import 'package:Dating/constants/styles.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThankYou extends StatefulWidget {
  ThankYou({Key? key, required this.title, required this.appManager})
      : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _ThankYouState createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou> {
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // this.jumpToHomeIfRequired();
    getPrefs();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
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
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Image.asset(
                  'assets/into1.png',
                  fit: BoxFit.fill,
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/congrats.gif', // Replace 'assets/animation.gif' with the path to your GIF file
                        width: 100, // Adjust the width as needed
                        height: 100, // Adjust the height as needed
                      ),
                      SizedBox(
                        height: 26,
                      ),
                      Text(
                        'Thank You!',
                        style: kObsTitle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 42,
                      ),
                      Text(
                        'Successfully registered with Dating. Welcome! Explore exciting opportunities and stay tuned for updates. Delighted to have you on board.',
                        style: kObsText,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 85.2,
                      ),
                      Container(
                        width: size.width,
                        height: 65,
                        // margin: EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: kButtonColor,
                          ),
                          child: Text("Go to Home", style: kButtonTextStyle),
                          onPressed: () async {
                            prefs.setBool('hasLoggedIn', true);
                            var loggedIn =
                                await widget.appManager.hasLoggedIn();
                            if (loggedIn['hasLoggedIn']) {
                              // Navigator.pushReplacementNamed(context, '/home', arguments: true);
                              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false, arguments: true);
                            }
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
