import 'dart:io';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'dart:io' show Platform;

class InitialScreen extends StatefulWidget {
  InitialScreen({Key? key, required this.title, required this.appManager})
      : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final localAuth = LocalAuthentication();
  bool isloaded = false;
  authenticateUser() async {
    var result = await this.widget.appManager.hasLoggedIn();
    if (result['hasLoggedIn']) {
      try {
        bool didAuthenticate = true;
        List<BiometricType> availableBiometrics =
            await localAuth.getAvailableBiometrics();
        if (availableBiometrics.length > 0) {
          didAuthenticate = await localAuth.authenticate(
            // biometricOnly: true,//Commneted on 22 Dec
            localizedReason: 'Please authenticate to proceed',
            // useErrorDialogs: true /* , stickyAuth: true *///Commneted on 22 Dec
          );
        }
        print("didAuthenticate $didAuthenticate");
        if (didAuthenticate) {
          if (!this.widget.appManager.appOpenedByNotification) {
            this.widget.appManager.appOpenedByNotification = false;
            // Navigator.pushReplacementNamed(context, "/home");
          }
        } else {
          print('authentication failed');
          this.authenticateUser();
          Navigator.pop(context);
        }
      } catch (e) {
        print("exception $e");
      }
    } else {
      if(isloaded == false){
      this.sleep1();
      }
    }
  }

  Future sleep1() {
    isloaded = true;
    return Future.delayed(
        const Duration(seconds: 5),
        () => {
              /* Remove this login check after local auth starts working properly  */
              this.widget.appManager.hasLoggedIn().then((result) {
                if (result['hasLoggedIn']) {
                  Navigator.pushReplacementNamed(context, "/home",
                      arguments: false);
                } else {
                  Navigator.pushReplacementNamed(context, "/obs");
                }
              })
            });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // this
    //     .widget
    //     .appManager
    //     .notifications
    //     .configureDidReceiveLocalNotificationSubject(this.context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      this.authenticateUser();
    }
    if(isloaded == false){
    this.sleep1();
    }
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/splash.gif',
          alignment: Alignment.center,
          fit: BoxFit.cover,
          width: size.width,
          height: size.height,
        ),
      ),
    );
  }
}

// @override
//   Widget build(BuildContext context) {
//     if (Platform.isIOS) {
//       this.authenticateUser();
//     }
//     this.sleep1();
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Container(
//         width: size.width,
//         height: size.height,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           image: DecorationImage(
//             image: AssetImage('assets/splash.png'),
//             fit: BoxFit.fill,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(height: 42),
//             // SvgPicture.asset('assets/logo.svg'),
//             // Container(
//             //   width: 165,
//             //   height: 471,
//             //   child: const Image(
//             //     image: AssetImage('assets/bg3.png'),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
