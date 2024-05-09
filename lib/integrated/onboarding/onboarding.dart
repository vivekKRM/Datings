import 'package:Dating/constants/styles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:Dating/integrated/onboarding/onboarding1.dart';
import 'package:Dating/integrated/onboarding/onboarding2.dart';
import 'package:Dating/integrated/onboarding/onboarding3.dart';

class Onboarding extends StatelessWidget {
   final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<Widget> screens = [
      Onboarding1(
        buttonCarouselController: carouselController,
      ),
      Onboarding2(
        buttonCarouselController: carouselController,
      ),
      Onboarding3(),
    ];
    return Scaffold(
      body: CarouselSlider(
        options: CarouselOptions(
          height: size.height,
          viewportFraction: 1.0,
          enableInfiniteScroll: false,
          autoPlay: false,
        ),
        carouselController: carouselController,
        items: screens.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return i;
            },
          );
        }).toList(),
      ),
    );
  }
}