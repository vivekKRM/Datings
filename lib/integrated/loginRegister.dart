import 'package:Dating/constants/styles.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginRegister extends StatelessWidget {
  LoginRegister({Key? key, required this.title, required this.appManager})
      : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // Disable back button
        return false;
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.asset(
              'assets/bg3.png',
              fit: BoxFit.fill,
            ),
            // Content
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50), // Top space for image
                Image.asset(
                  'assets/appicon.png',
                  height: 70,
                  // You can customize the height and alignment of the image
                ),
                // SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      MarqueeText(
                          'Company: HOLY ANGEL MARINE SERVICES PVT LTD;  Ship: Oil Tanker,Crude Oil Tanker;  Rank: 3rd Officer,Electro Technical Officer,Pumpman,AB;  DOJ: 2024-03-02 18:27:26'),
                      Container(
                        color: Colors.white,
                        height: 1,
                      ),
                      MarqueeText(
                          'GENMARCO MARITIME SERVICES PVT LTD;  Ship: Oil Tanker,Crude Oil Tanker,Oil/Chem Tanker,Product Tanker,Chemical Tanker;  Rank: 3rd Officer,Electro Technical Officer,Pumpman,AB,AB;  DOJ: 2024-03-02 15:06:42'),
                      Container(
                        color: Colors.white,
                        height: 1,
                      ),
                      MarqueeText(
                          'Company: GENMARCO MARITIME SERVICES PVT LTD;  Ship: Oil Tanker,Crude Oil Tanker,Oil/Chem Tanker,Product Tanker,Chemical Tanker,Oil/Chem Tanker,Product Tanker,Chemical Tanker;  Rank: 3rd Officer,Electro Technical Officer,Pumpman,AB,AB,AB;  DOJ: 2024-03-02 15:06:24'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.4,
                        // height: 5
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: kButtonColor,
                          ),
                          child: Text('Login', style: kButtonTextStyle),
                          onPressed: () {
                            Navigator.pushNamed(context, "/login");
                          },
                        ),
                      ),
                      Container(
                        width: size.width * 0.4,
                        // height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: kButtonColor,
                          ),
                          child: Text('Register', style: kButtonTextStyle),
                          onPressed: () {
                            Navigator.pushNamed(context, "/personal");
                          },
                        ),
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

class MarqueeText extends StatelessWidget {
  final String text;

  const MarqueeText(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      // Wrap Marquee with a Container and provide a fixed height
      child: SizedBox(
        height: 40, // Adjust height as needed
        child: Marquee(
          text: text,
          style: kMarqueeTextStyle,
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          blankSpace: 20.0,
          velocity: 50.0,
          pauseAfterRound: Duration(seconds: 1),
          showFadingOnlyWhenScrolling: true,
          fadingEdgeStartFraction: 0.1,
          fadingEdgeEndFraction: 0.1,
          startPadding: 10.0,
          accelerationDuration: Duration(seconds: 1),
          accelerationCurve: Curves.linear,
          decelerationDuration: Duration(milliseconds: 500),
          decelerationCurve: Curves.easeOut,
        ),
      ),
    );
  }
}
