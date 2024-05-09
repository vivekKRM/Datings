import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getBulkResumePost.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BulkApplyJob extends StatefulWidget {
  BulkApplyJob({
    Key? key,
    required this.title,
    required this.appManager,
    required this.jobid,
  }) : super(key: key);

  final String title;
  final AppManager appManager;
  final String jobid;
  @override
  _BulkApplyJobState createState() => _BulkApplyJobState();
}

class _BulkApplyJobState extends State<BulkApplyJob> {
  late FToast fToast;
  String token = '';
  String user_id = '';
  late SharedPreferences prefs;
  List<Result?> certificateType = [];
  List<bool> isCheckedList = [];

  Future<void> getJobCompany() async {
    final requestBody = {"id": widget.jobid};
    widget.appManager.apis
        .getJobCompany(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        setState(() {
          certificateType = response.user;
          isCheckedList =
              List.generate(certificateType.length, (index) => true);
        });
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to get job company");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get job company: $error");
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
                  'Resume has been sent suucessfully for the post.',
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

  Future<void> submitApplyJob() async {
    String user_id = prefs.getString('sId') ?? '';
    List<String> selectedCourses = [];
    for (int i = 0; i < isCheckedList.length; i++) {
      if (isCheckedList[i]) {
        selectedCourses.add(certificateType[i]?.seajob_id ?? '');
      }
    }
    print('Selected courses: $selectedCourses');
    String commaSeparated = selectedCourses.join(',');
    final requestBody = {
      'user_id': user_id,
      'compid': commaSeparated,
      'bulk_resume': 'bulk_resume',
    };
    widget.appManager.apis
        .applyJobResume(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        _showCustomDialog(context);
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to bulk apply job post");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to bulk apply job post: $error");
    });
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
    getJobCompany();
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
            'Apply Jobs',
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
                          height: size.height * 0.8,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: certificateType.length,
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
                                          Checkbox(
                                            activeColor: kButtonColor,
                                            value: isCheckedList[index],
                                            onChanged: (newValue) {
                                              setState(() {
                                                isCheckedList[index] =
                                                    newValue!;
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${certificateType[index]?.seajob_name ?? ''}',
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
                            child: Text('Apply Jobs', style: kButtonTextStyle),
                            onPressed: () {
                              if (isCheckedList.contains(true)) {
                                // At least one checkbox is checked
                                submitApplyJob();
                              } else {
                                showToast(
                                    'Please select a company to apply for job',
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
