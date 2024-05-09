import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getCity.dart';
import 'package:Dating/json/getCountry.dart';
import 'package:Dating/json/getCourse.dart';
import 'package:Dating/json/getCourseSelected.dart';
import 'package:Dating/json/getState.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursesDetails extends StatefulWidget {
  CoursesDetails(
      {Key? key,
      required this.title,
      required this.appManager,
      required this.updateBtn})
      : super(key: key);

  final String title;
  final AppManager appManager;
  final bool updateBtn;

  @override
  _CoursesDetailsState createState() => _CoursesDetailsState();
}

class _CoursesDetailsState extends State<CoursesDetails> {
  late FToast fToast;
  String token = '';
  String user_id = '';
  late SharedPreferences prefs;
  List<Courses> certificateType = [];
  List<Result?> certificateSelected = [];
  List<bool> isCheckedList = []; // Initialize all checkboxes as unchecked

  Future<void> getCourse() async {
    final requestBody = {"": ''};
    widget.appManager.apis
        .getCourse(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        setState(() {
          certificateType = response.courses;
          isCheckedList =
              List.generate(certificateType.length, (index) => false);
        });
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to get courses");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get courses: $error");
    });
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 310,
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/congrats.gif', // Replace 'assets/animation.gif' with the path to your GIF file
                  width: 80, // Adjust the width as needed
                  height: 80, // Adjust the height as needed
                ),
                SizedBox(height: 10),
                Text(
                    textAlign: TextAlign.center,
                    'Congratulations',
                    style: kCongratsTextStyle),
                SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  widget.updateBtn == true
                      ? "Your information has been updated successfully."
                      : 'Your information has been submitted successfully.',
                  style: kObsText,
                ),
                SizedBox(height: 34),
                Container(
                  width: size.width,
                  height: 65,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: kButtonColor,
                    ),
                    child: Text('OK', style: kButtonTextStyle),
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.updateBtn == true
                          ? Navigator.pop(context)
                          : Navigator.pushNamed(context, "/dangerous",
                              arguments: false);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> submitCoursesDetails() async {
    String user_id = prefs.getString('sId') ?? '';
    List<String> selectedCourses = [];
    for (int i = 0; i < isCheckedList.length; i++) {
      if (isCheckedList[i]) {
        selectedCourses.add(certificateType[i].seajob_id);
      }
    }
    print('Selected courses: $selectedCourses');
    String commaSeparated = selectedCourses.join(',');
    final requestBody = {
      'user_id': user_id,
      'course': commaSeparated,
    };
    widget.appManager.apis
        .sendCourse(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        // prefs.setString('sId', response?.user_id ?? '');
        _showCustomDialog(context);
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to register");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to register: $error");
    });
  }

  Future<void> updateCourses() async {
    String user_id = prefs.getString('sId') ?? '';
    List<String> selectedCourses = [];
    for (int i = 0; i < isCheckedList.length; i++) {
      if (isCheckedList[i]) {
        selectedCourses.add(certificateSelected[i]?.seajob_id ?? '');
      }
    }
    print('Selected courses: $selectedCourses');
    String commaSeparated = selectedCourses.join(',');
    final requestBody = {
      'user_id': user_id,
      'course_id': commaSeparated,
    };
    widget.appManager.apis
        .updateCourse(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        _showCustomDialog(context);
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to register");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to register: $error");
    });
  }

  Future<void> getCoursesDetails(String user_id) async {
    if (user_id != "") {
      final requestBody = {"user_id": user_id};
      widget.appManager.apis
          .getCourseDetails(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // prefs.setString('sId', response?.user?.id ?? '');
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            certificateSelected = response?.user ?? [];
            isCheckedList =
                List.generate(certificateSelected.length, (index) => false);
            for (int i = 0; i < certificateSelected.length; i++) {
              if ((certificateSelected[i]?.Datingselect ?? 0) == 1) {
                isCheckedList[i] = true;
              }
            }
          });
        } else if (response?.status == 201) {
          showToast(response?.message ?? '', 2, kToastColor, context);
        } else if (response?.status == 502) {
          await widget.appManager.clearLoggedIn();
          if (widget.appManager.islogout == true) {
            widget.appManager.utils.isPatientExitDialogShown = false;
            Navigator.pushNamedAndRemoveUntil(
                context, '/obs', (route) => false);
          }
        } else {
          print("Failed to get courses data");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to get courses data: $error");
      });
    } else {
      showToast('Please get user_id', 2, kToastColor, context);
    }
  }

  void showToast(
      String msg, int duration, Color bgColor, BuildContext context) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // this.jumpToHomeIfRequired();
    getPrefs();
    fToast = FToast();
    fToast.init(context);
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('authToken') ?? '';
    user_id = prefs.getString('sId') ?? '';
    widget.updateBtn ? getCoursesDetails(user_id) : getCourse();
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
              'Courses',
              style: kHeaderTextStyle,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  widget.updateBtn ? updateCourses() : submitCoursesDetails();
                },
                child: Text(
                  widget.updateBtn == true ? 'Update' : 'Next',
                  style: kBarButtonTextStyle,
                ),
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Container(
                color: backgroundColor,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.updateBtn
                              ? certificateSelected.length
                              : certificateType.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFECEDF5),
                                    ),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          activeColor: kButtonColor,
                                          value: isCheckedList[index],
                                          onChanged: (newValue) {
                                            setState(() {
                                              isCheckedList[index] = newValue!;
                                            });
                                          },
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${widget.updateBtn ? certificateSelected[index]?.seajob_name : certificateType[index].seajob_name}',
                                            style: kalertTitleTextStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        height: size.height * 0.85,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
