import 'package:carousel_slider/carousel_controller.dart';
import 'package:Dating/constants/styles.dart';
import 'package:flutter/material.dart';


class Onboarding1 extends StatelessWidget {
late final CarouselController buttonCarouselController;

  Onboarding1({
    required this.buttonCarouselController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.6,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: size.width,
                    color: kObsColor1,
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
                    width: 22,
                    height: 7,
                    decoration: BoxDecoration(
                      color: kObsColor1,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(width: 12),
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
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Track as your health improves',
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
                  'DocuVitals app will help you track your health metrics as you move toward speedy recovery and fitness.',
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
              width: size.width,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.fromLTRB(20, size.height * 0.019, 20, 20),
              child: Container(
                  width: size.height * 0.08,
                  height: size.height * 0.08,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: kButtonColor,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: size.height * 0.035,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    buttonCarouselController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            )
          ],
        ),
      ),
    );
  }
}
