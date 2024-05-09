import 'package:Dating/constants/styles.dart';
import 'package:Dating/integrated/dashboardScreen.dart';
import 'package:Dating/json/getCompany.dart';
import 'package:Dating/json/getRank.dart';
import 'package:Dating/json/getShip.dart';
import 'package:Dating/json/jobSearch.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HideCompany extends StatefulWidget {
  HideCompany({
    Key? key,
    required this.title,
    required this.appManager,
    required this.status,
  }) : super(key: key);

  final String title;
  final AppManager appManager;
  final String status;

  @override
  _HideCompanyState createState() => _HideCompanyState();
}

class _HideCompanyState extends State<HideCompany> {
  late FToast fToast;
  String token = '';
  String user_id = '';
  String comp_id = '';
  int page = 1;
  List<bool> switchValues = [];
  late SharedPreferences prefs;
  List<Company> companieslist = [];
  ScrollController _scrollController = ScrollController();
  Future<void> submitHide(String status, int index, bool values) async {
    String user_id = prefs.getString('sId') ?? '';
    final requestBody = {
      'user_id': user_id,
      'compid': comp_id,
      'hide': status == 'hide' ? 'unhide' : 'hide',
    };
    print(requestBody);
    widget.appManager.apis
        .hideunhide(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        setState(() {
           switchValues[index] = values;
        });
        _showCustomDialog(context, status);
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

  Future<void> getcompanyList() async {
    if (user_id != "") {
      final requestBody = {
        'from': page,
        'user_id': user_id,
      };
      widget.appManager.apis
          .getCompany(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            companieslist.addAll(response?.company ?? []);
            //  switchValues = List.generate(companieslist.length, (index) => false);
            switchValues = List.generate(companieslist.length, (index) {
              if (companieslist[index].status == 1) {
                return false;
              } else {
                return true;
              }
            });
            page++;
          });
        } else if (response?.status == 201) {
          showToast(response?.message ?? '', 2, kToastColor, context);
          showCustomAlertDialog('Warning', response?.message ?? '');
        } else if (response?.status == 502) {
         showLogoutDialog(BuildContext context) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LogoutAlert(
                  title: 'Active/Inactive Status',
                  subtitle: response?.message ?? '',
                  islogout: false,
                  logoutAction: () async {
                    await widget.appManager.clearLoggedIn();
                    if (widget.appManager.islogout == true) {
                      widget.appManager.utils.isPatientExitDialogShown = false;
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/obs', (route) => false);
                    }
                  },
                );
              },
            );
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

  void _showCustomDialog(BuildContext context, String ststus) {
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
                  "Selected company has been " +
                      (ststus == "hide"
                          ? 'Unhide successfully.'
                          : 'Hide successfully.'),
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
                      // Navigator.pop(context);
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

  void _showDropdown(BuildContext context, String status, int index, bool values) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return HideAlert(
          logoutAction: () async {
            print('Performing hide/unhide action...');
            submitHide(status, index, values);
            Navigator.of(context).pop();
          },
          hide: status,
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

  void showCustomAlertDialog(String title, String subtitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: kNamePainStyle,
          ),
          content: Text(
            subtitle,
            style: kTableHeaderTextStyle,
          ),
          actions: <Widget>[
            // OK Button
            TextButton(
              onPressed: () {
                // Close the dialog and do something
                Navigator.of(context).pop();
                // Add your OK button action here
              },
              child: Text(
                'OK',
                style: kCardValueTextStyle,
              ),
            ),
            // Cancel Button
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
                // Add your Cancel button action here
              },
              child: Text(
                'Cancel',
                style: kCardValueTextStyle,
              ),
            ),
          ],
        );
      },
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
    _scrollController.addListener(() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Reached the end of the list
      getcompanyList(); // Fetch more data
    }
  });
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('authToken') ?? '';
    user_id = prefs.getString('sId') ?? '';
    getcompanyList();
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
            'Hide/Unhide Company',
            style: kHeaderTextStyle,
          ),
        ),
        body:  SingleChildScrollView(
            child: Container(
              color: kAppBarColor,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: size.height * 0.85,
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: companieslist.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFECEDF5),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              '${index + 1}.  ',
                                              style: kHeaderTextStyle,
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${companieslist[index].name}',
                                                style: kDropDownTextStyle,
                                              ),
                                            ),
                                            Switch(
                                              value: switchValues[index],
                                              onChanged: (value) {
                                                setState(() {
                                                  if (value) {
                                                    comp_id =
                                                        companieslist[index]
                                                            .locationId;
                                                    _showDropdown(
                                                        context, 'hide', index, value);
                                                  } else {
                                                    comp_id =
                                                        companieslist[index]
                                                            .locationId;
                                                    _showDropdown(
                                                        context, 'unhide', index, value);
                                                  }
                                                  // switchValues[index] = value;
                                                });
                                              },
                                            ),
                                          ],
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
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}

//Hide/Unhide Class
class HideAlert extends StatelessWidget {
  final VoidCallback logoutAction; // Callback for logout action
  final String hide;
  HideAlert({
    required this.logoutAction,
    required this.hide,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        hide == 'hide' ? 'Unhide Company' : 'Hide Company',
        style: kHeaderTextStyle,
      ),
      content: Text(
        hide == 'hide'
            ? 'Are you sure you want to unhide selected company?'
            : 'Are you sure you want to hide selected company?',
        style: kObsText,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            // getcompanyList();
          },
          child: Text(
            'Not now',
            style: klogoutcTextStyle,
          ),
        ),
        TextButton(
          onPressed: logoutAction,
          child: Text(hide == 'hide' ? 'Unhide' : 'Hide',
              style: klogoutcTextStyle //klogoutTextStyle,
              ),
        ),
      ],
    );
  }
}
