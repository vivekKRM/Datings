import 'package:Dating/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final Widget leading;
  final String titleText;
  final BuildContext context;

  CustomAppbar({
    required this.leading,
    required this.titleText,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  leading,
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      titleText,
                      style: kNameTextStyle,
                      // maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/notif",
                              arguments: false);
              },
              child: Icon(Icons.notifications, color: kDashboardColor),
              ),
              SizedBox(width: 15,),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/consent",
                              arguments: false);
              },
              child: Icon(Icons.settings, color: kDashboardColor),
              ),
          ],
        ),
      ),
    );
  }
}
