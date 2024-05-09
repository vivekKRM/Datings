import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getRank.dart';
import 'package:Dating/json/getShip.dart';
import 'package:Dating/json/jobSearch.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../json/getSingleCompany.dart';

class JobDetails extends StatefulWidget {
  JobDetails({
    Key? key,
    required this.title,
    required this.appManager,
    required this.comp_id,
  }) : super(key: key);

  final String title;
  final AppManager appManager;
  final String comp_id;

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  String token = '';
  String user_id = '';
  late FToast fToast;
  late SharedPreferences prefs;
  String postid = '';
  String compid = '';
  late Result? getcompany = null;
  List<String> texts = [
    'Select Ship',
    'Select Rank',
  ];

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

  Future<void> getsearchjob(String user_id) async {
    if (widget.comp_id != "") {
      final requestBody = {
        'seajob_id': widget.comp_id,
      };
      widget.appManager.apis
          .singlesearchJob(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // prefs.setString('sId', response?.user?.id ?? '');
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            getcompany = (response?.user) as Result?;
            postid = response?.user?.jobpostId ?? '';
            compid = response?.user?.DatingCompId ?? '';
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
          print("Failed to get job search data");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to get job search data: $error");
      });
    } else {
      showToast('Please get user_id', 2, kToastColor, context);
    }
  }

  Future<void> applyJob(String user_id) async {
    if (user_id != "" && postid != "") {
      final requestBody = {
        'user_id': user_id,
        'postid': postid,
        'compid': compid,
      };
      widget.appManager.apis
          .applyjobdetails(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // prefs.setString('sId', response?.user?.id ?? '');
          showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          _showCustomDialog(context);
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
          print("Failed to apply job detail data");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to apply job detail data: $error");
      });
    } else {
      showToast('Please get user_id', 2, kToastColor, context);
    }
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
                  "Your have successfully applied for this job.",
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    getPrefs();
    fToast.init(context);
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('sId') ?? '';
    getsearchjob(user_id);
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
            'Job Details',
            style: kHeaderTextStyle,
          ),
        ),
        body: Container(
          color: kAppBarColor,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textAlign: TextAlign.left,
                          getcompany?.DatingCompanyName ?? '',
                          style: kDropDownTextStyle,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          textAlign: TextAlign.left,
                          'Posted on: ' + (getcompany?.DatingCreated ?? ''),
                          style: kLoginTextFieldLabel,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Job apply ranks: ' + (getcompany?.DatingDesc ?? ''),
                          style: kLoginTextFieldLabel,
                        ),
                      ],
                    ),
                  ),
                  height: 350,
                ),
                Container(
                  width: size.width,
                  height: 65,
                  // margin: EdgeInsets.only(bottom: 30, top: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: kButtonColor,
                    ),
                    child: Text('Apply Job', style: kButtonTextStyle),
                    onPressed: () {
                      applyJob(user_id);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
