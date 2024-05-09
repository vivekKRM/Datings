import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getAcademic.dart';
import 'package:Dating/json/getCertificate.dart';
import 'package:Dating/json/getCountry.dart';
import 'package:Dating/json/getNationality.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAcademicDetails extends StatefulWidget {
  EditAcademicDetails(
      {Key? key,
      required this.title,
      required this.appManager,
      required this.updateBtn})
      : super(key: key);

  final String title;
  final AppManager appManager;
  final bool updateBtn;

  @override
  _EditAcademicDetailsState createState() => _EditAcademicDetailsState();
}

class _EditAcademicDetailsState extends State<EditAcademicDetails> {
  late FToast fToast;
  List<String> texts = [
    'SSC',
    'HSC',
    'Degree',
    'Pre Sea Training',
    'Other',
  ];
  String token = '';
  String user_id = '';
  List<Result?> academic = [];
  late SharedPreferences prefs;
  List<Certificates> certificateType = [];
  bool isExpanded = false;
  bool isExpanded1 = true;
  bool isExpanded2 = true;
  bool isExpanded3 = true;
  bool isExpanded4 = true;
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
                          : Navigator.pushNamed(context, "/courses",
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

  Future<void> submitAcademicDetails() async {
    FocusScope.of(context).unfocus();
    String user_id = prefs.getString('sId') ?? '';
    final requestBody = {
      'page': '10',
      'user_id': user_id,
    };

    for (int i = 0; i < academic.length; i++) {
      requestBody['id${i + 1}'] = academic[i]?.Datingid ?? '';
      requestBody['edu${i + 1}'] = academic[i]?.education ?? '';
      requestBody['board${i + 1}'] = academic[i]?.board ?? '';
      requestBody['year${i + 1}'] = academic[i]?.year ?? '';
      requestBody['percentage${i + 1}'] = academic[i]?.percentage ?? '';
    }
    if (widget.updateBtn == true) {
      requestBody['edit'] = 'e';
    }
    widget.appManager.apis
        .updateRegister(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        prefs.setString('sId', response?.user_id ?? '');
        _showCustomDialog(context);
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to submit academic details");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to submit academic details: $error");
    });
  }

  Future<void> getAcademicDetails(String user_id) async {
    if (user_id != "") {
      final requestBody = {"user_id": user_id};
      widget.appManager.apis
          .getAcademic(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            academic = [];
            academic = response?.user ?? [];
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
          print("Failed to get academic data");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to get academic data: $error");
      });
    } else {
      showToast('Please get user_id', 2, kToastColor, context);
    }
  }

  bool isValidForm() {
    for (int i = 0; i < academic.length; i++) {
      if (academic[0]?.board == '') {
        showToast('Please enter board for ${academic[0]?.education}', 2,
            kToastColor, context);
        return false;
      } else if (academic[0]?.year == '') {
        showToast('Please enter passing year for ${academic[0]?.education}', 2,
            kToastColor, context);
        return false;
      } else if (academic[0]?.percentage == '') {
        showToast(
            'please enter percentage scored for ${academic[0]?.education}',
            2,
            kToastColor,
            context);
        return false;
      } else {
        print('Proceed');
        FocusScope.of(context).unfocus();
        return true;
      }
    }
    return false;
  }

  bool isBoardFieldFilled(String? board) {
    return board?.isNotEmpty ?? false;
  }

  bool isPercentageAndYearFilled(String? percentage, String? year) {
    return (percentage?.isNotEmpty ?? false) && (year?.isNotEmpty ?? false);
  }

  String? validateFields() {
    for (int i = 0; i < academic.length; i++) {
      if (isBoardFieldFilled(academic[i]?.board)) {
        if (!isPercentageAndYearFilled(
            academic[i]?.percentage, academic[i]?.year)) {
          return 'Please fill in percentage and year for all filled boards';
        }
      }
    }
    return null;
  }

  bool isYearValidate() {
    for (int i = 0; i < academic.length - 1; i++) {
      String year1 = academic[i]?.year ?? '';
      String year2 = academic[i + 1]?.year ?? '';
      if (year1.isNotEmpty && year2.isNotEmpty) {
        if (int.tryParse(year1) != null && int.tryParse(year2) != null) {
          if (int.parse(year1) >= int.parse(year2)) {
            showToast('Please enter correct year according to academic qualifications', 4,
                kToastColor, context);
            return false;
          }
        }
      }
    }
    return true;
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
    widget.updateBtn ? getAcademicDetails(user_id) : null;
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
            'Academic Qualification',
            style: kHeaderTextStyle,
          ),
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
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: academic.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFECEDF5),
                                  ),
                                  padding: EdgeInsets.only(
                                      top: 15, bottom: 15, left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                texts[index],
                                                style: kvaccineTextStyle,
                                              ),
                                              // IconButton(
                                              //   icon: isExpanded1
                                              //       ? Icon(
                                              //           Icons.keyboard_arrow_down)
                                              //       : Icon(
                                              //           Icons.keyboard_arrow_up),
                                              //   onPressed: () {
                                              //     setState(() {
                                              //       isExpanded1 = !isExpanded1;
                                              //     });
                                              //   },
                                              //   iconSize:
                                              //       30, // Adjust the size as needed
                                              //   color: Colors
                                              //       .black, // Adjust the color as needed
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 15),
                                        margin: EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: kLoginTextFieldFillColor,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.school_outlined,
                                                size: 20,
                                                color: kLoginIconColor),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: TextFormField(
                                                initialValue:
                                                    academic[index]?.board ??
                                                        '',
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                  hintText:
                                                      'Board/University/Institute',
                                                  hintStyle:
                                                      kLoginTextFieldTextStyle,
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    print(value);
                                                    academic[index]?.board =
                                                        value;
                                                  });
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 15),
                                        margin: EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: kLoginTextFieldFillColor,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.date_range_outlined,
                                                size: 20,
                                                color: kLoginIconColor),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: TextFormField(
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      4)
                                                ],
                                                initialValue:
                                                    academic[index]?.year ?? '',
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  // contentPadding: EdgeInsets.symmetric(
                                                  //     vertical: 8, horizontal: 0),
                                                  isDense: true,
                                                  hintText: 'Passing Year',
                                                  hintStyle:
                                                      kLoginTextFieldTextStyle,
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    print(value);
                                                    academic[index]?.year =
                                                        value;
                                                  });
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 15),
                                        margin: EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: kLoginTextFieldFillColor,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.percent_outlined,
                                                size: 20,
                                                color: kLoginIconColor),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: TextFormField(
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      3)
                                                ],
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        decimal: true),
                                                initialValue: academic[index]
                                                        ?.percentage ??
                                                    '',
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  // contentPadding: EdgeInsets.symmetric(
                                                  //     vertical: 8, horizontal: 0),
                                                  isDense: true,
                                                  hintText: 'Percentage',
                                                  hintStyle:
                                                      kLoginTextFieldTextStyle,
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    print(value);
                                                    academic[index]
                                                        ?.percentage = value;
                                                  });
                                                },
                                              ),
                                            )
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
                      height: isExpanded
                          ? academic.length * 70
                          : academic.length * 340,
                    ),
                    Container(
                      width: size.width,
                      height: 65,
                      margin: EdgeInsets.only(bottom: 30, top: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: kButtonColor,
                        ),
                        child: Text(
                            widget.updateBtn == true ? 'Update' : 'Next',
                            style: kButtonTextStyle),
                        onPressed: () {
                          String? validationResult = validateFields();
                          bool validationResults = isYearValidate();
                          if (validationResult != null) {
                            showToast(
                                validationResult, 5, kToastColor, context);
                          } else {
                            if (validationResults == true) {
                              submitAcademicDetails();
                            }
                          }
                        },
                      ),
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
