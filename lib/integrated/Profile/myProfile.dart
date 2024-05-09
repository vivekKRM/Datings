import 'package:Dating/constants/styles.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  MyProfile({Key? key, required this.title, required this.appManager})
      : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final List<String> items = [
    'Personal Details',
    'Contact Details',
    'Passport And Visa Details',
    'Seaman Book Details',
    'Certificate Details',
    'Academic Details',
    'Course Details',
    'DCE Details',
    'Sea Experience Details',
    'Profile & Exp Details',
    'Availability'
  ];
  @override
  Widget build(BuildContext context) {
     return WillPopScope(
      onWillPop: () async {
        // Disable back button
        return false;
      },
      child: Scaffold(
   
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: kAppBarColor,
        surfaceTintColor: kAppBarColor,
        title: Text(
          'My Profile',
          style: kHeaderTextStyle,
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.white,//kAppBarColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,//Color(0xFFECEDF5),
                  borderRadius: BorderRadius.circular(10),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.1),
                  //     spreadRadius: 2,
                  //     blurRadius: 5,
                  //     offset: Offset(0, 3),
                  //   ),
                  // ],
                ),
                child: ListTile(
                  title: Text(
                    items[index],
                    style: kalertTitleTextStyle,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      index == 0
                          ? Navigator.pushNamed(context, "/editpersonal",
                              arguments: true)
                          : index == 1
                              ? Navigator.pushNamed(context, "/contact",
                                  arguments: true)
                              : index == 2
                                  ? Navigator.pushNamed(context, "/passport",
                                      arguments: true)
                                  : index == 3
                                      ? Navigator.pushNamed(
                                          context, "/editseaman",
                                          arguments: true)
                                      : index == 5
                                          ? Navigator.pushNamed(
                                              context, "/editacademic",
                                              arguments: true)
                                          : index == 4
                                              ? Navigator.pushNamed(
                                                  context, "/editcompetency",
                                                  arguments: true)
                                                  : index == 6
                                          ? Navigator.pushNamed(
                                              context, "/courses",
                                              arguments: true)
                                               : index == 8
                                          ? Navigator.pushNamed(
                                              context, "/editseaexperience",
                                              arguments: true)
                                              : index == 9
                                          ? Navigator.pushNamed(
                                              context, "/profilexperience",
                                              arguments: true)
                                              : index == 10
                                          ? Navigator.pushNamed(
                                              context, "/job",
                                              arguments: true)
                                               : index == 7
                                          ? Navigator.pushNamed(
                                              context, "/dangerous",
                                              arguments: true)
                                              : null;
                      print('Edit button pressed for ${items[index]}');
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    )
     );
  }
}
