import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getBulkResumePost.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BulkResumePost extends StatefulWidget {
  BulkResumePost({
    Key? key,
    required this.title,
    required this.appManager,
  }) : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _BulkResumePostState createState() => _BulkResumePostState();
}

class _BulkResumePostState extends State<BulkResumePost> {
  late FToast fToast;
  String token = '';
  String user_id = '';
  String jobid = '';
  List<Result?> resumePost = [];
  late SharedPreferences prefs;
  List<bool> isCheckedList = [];

  Future<void> getBulkResumePost() async {
    final requestBody = {"": ''};
    widget.appManager.apis
        .getBulkResume(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        setState(() {
          resumePost = response.user ?? [];
          isCheckedList = List.generate(resumePost.length, (index) => false);
        });
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to get bulk resume post");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get  bulk resume post: $error");
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
                  'Your information has been submitted successfully.',
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
                      Navigator.pop(context);
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
    getBulkResumePost();
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
            'Bulk Resume Post',
            style: kHeaderTextStyle,
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              color: kAppBarColor,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 80),
                          height: size.height * 0.85,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: resumePost.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
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
                                          Radio(
                                            activeColor: kButtonColor,
                                            value: true,
                                            groupValue: isCheckedList[index],
                                            onChanged: (newValue) {
                                              setState(() {
                                                // Set the selected index to true and other indices to false
                                                for (int i = 0;
                                                    i < isCheckedList.length;
                                                    i++) {
                                                  isCheckedList[i] = i == index;
                                                  print(resumePost[index]
                                                          ?.seajob_name ??
                                                      '');
                                                  jobid = resumePost[index]
                                                          ?.seajob_id ??
                                                      '';
                                                }
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${resumePost[index]?.seajob_name ?? ''}',
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
                        ),
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
                            child: Text('Next', style: kButtonTextStyle),
                            onPressed: () {
                              if (jobid != "") {
                                Navigator.pushNamed(
                                  context,
                                  "/bulkapply",
                                  arguments: jobid,
                                );
                              } else {
                                showToast(
                                    'Please select a resume post to proceed further',
                                    5,
                                    kToastColor,
                                    context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
