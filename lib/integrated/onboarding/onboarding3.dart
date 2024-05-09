import 'package:Dating/constants/styles.dart';
import 'package:flutter/material.dart';

class Onboarding3 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

                  Container(
                    width: size.width,
                    height: size.height * 0.6,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 30),
                          width: size.width,
                          color: kObsColor3,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                              child: Image(
                                width: size.width,
                                height: size.height * 0.45,
                                image: AssetImage('assets/facebook.png'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 13,
                          height: 7,
                          decoration: BoxDecoration(
                            color: kBoxInActiveColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        SizedBox(width: 6),
                        Container(
                          width: 13,
                          height: 7,
                          decoration: BoxDecoration(
                            color: kBoxInActiveColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        SizedBox(width: 12),
                        Container(
                          width: 22,
                          height: 7,
                          decoration: BoxDecoration(
                            color: kObsColor1,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Touchless caregiving',
                      style: TextStyle(
                    fontSize: size.height * 0.032,
                    fontWeight: FontWeight.w600,
                   ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, size.height * 0.019, 20, size.height * 0.019),
                      child: Text(
                        'Communicate with your caregivers using instant messaging and image upload.',
                        style: TextStyle(
                          fontSize: size.height * 0.0175,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  width: size.width,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: kButtonColor,
                    ),
                    child: Text('Get Started', style: kButtonTextStyle),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ),
                SizedBox(height: 30),
                

                

          ],
        ),
      ),
    );
  }
}
