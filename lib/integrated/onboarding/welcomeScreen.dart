import 'package:Dating/constants/styles.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen(
      {Key? key,
      required this.title,
      required this.appManager,
      required this.isRegister})
      : super(key: key);

  final String title;
  final AppManager appManager;
  final bool isRegister;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Start the animation when the screen is loaded
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        opacity = 1.0;
      });
    });
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

              AnimatedOpacity(
                opacity: opacity,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/into2.png',
                        height: 298.2,
                      ),
                      SizedBox(
                        height: 17.04,
                      ),
                      Text(
                        widget.isRegister
                            ? 'Welcome to Dating'
                            : 'Welcome back to Dating',
                        style: kObsTitle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 17.04,
                      ),
                      Text(
                        'All maritime jobs are posted by licensed manning agencies and maritime companies.',
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
                          child: Text("Continue", style: kButtonTextStyle),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
