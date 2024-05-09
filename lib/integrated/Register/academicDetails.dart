import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getCertificate.dart';
import 'package:Dating/json/getCountry.dart';
import 'package:Dating/json/getNationality.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcademicDetails extends StatefulWidget {
  AcademicDetails({Key? key, required this.title, required this.appManager})
      : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _AcademicDetailsState createState() => _AcademicDetailsState();
}

class _AcademicDetailsState extends State<AcademicDetails> {
  late FToast fToast;
  List<String> texts = [
    'Board/University/Institute',
    'Passing Year',
    'Percentage',
  ];
  String token = '';
  late SharedPreferences prefs;
  TextEditingController _sscBoardController = TextEditingController();
  TextEditingController _sscPassingController = TextEditingController();
  TextEditingController _sscPercentageController = TextEditingController();
  TextEditingController _hscBoardController = TextEditingController();
  TextEditingController _hscPassingController = TextEditingController();
  TextEditingController _hscPercentageController = TextEditingController();
  TextEditingController _degreeBoardController = TextEditingController();
  TextEditingController _degreePassingController = TextEditingController();
  TextEditingController _degreePercentageController = TextEditingController();
  TextEditingController _preTrainingBoardController = TextEditingController();
  TextEditingController _preTrainingPassingController = TextEditingController();
  TextEditingController _preTrainingPercentageController =
      TextEditingController();
  TextEditingController _otherBoardController = TextEditingController();
  TextEditingController _otherPassingController = TextEditingController();
  TextEditingController _otherPercentageController = TextEditingController();

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
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 0, top: 0),
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
                      Navigator.pushNamed(context, "/courses", arguments: false);
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
    String user_id = prefs.getString('sId') ?? '';
    final requestBody = {
      'page': '14',
      'user_id': user_id,
      'edu1': 'ssc',
      'edu2': _hscBoardController.text == '' ? '' : 'hsc',
      'edu3': _degreeBoardController.text == '' ? '' : 'degree',
      'edu4': _preTrainingBoardController.text == '' ? '' : 'pre',
      'edu5': _otherBoardController.text == '' ? '' : 'other',
      'board1': _sscBoardController.text,
      'year1': _sscPassingController.text,
      'percentage1': _sscPercentageController.text,
      'board2': _hscBoardController.text,
      'year2': _hscPassingController.text,
      'percentage2': _hscPercentageController.text,
      'board3': _degreeBoardController.text,
      'year3': _degreePassingController.text,
      'percentage3': _degreePercentageController.text,
      'board4': _preTrainingBoardController.text,
      'year4': _preTrainingPassingController.text,
      'percentage4': _preTrainingPercentageController.text,
      'board5': _otherBoardController.text,
      'year5': _otherPassingController.text,
      'percentage5': _otherPercentageController.text,
    };
    widget.appManager.apis
        .sendRegister(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        prefs.setString('sId', response?.user_id ?? '');
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

  bool isValidForm() {
    if (_sscBoardController.text == '') {
      showToast('Please enter SSC Board/University/Institute', 2, kToastColor,
          context);
      return false;
    } else if (_sscPassingController.text == '') {
      showToast('Please enter passing year for SSC', 2, kToastColor, context);
      return false;
    } else if (_sscPercentageController.text == '') {
      showToast(
          'please enter percentage scored for SSC', 2, kToastColor, context);
      return false;
    } else if (_hscBoardController.text != '') {
      if (_hscPassingController.text == '') {
        showToast('Please enter passing year for HSC', 2, kToastColor, context);
        return false;
      } else if (_hscPercentageController.text == '') {
        showToast(
            'please enter percentage scored for HSC', 2, kToastColor, context);
        return false;
      }
      return true;
    } else if (_degreeBoardController.text != '') {
      if (_degreePassingController.text == '') {
        showToast(
            'please enter passing year for Degree', 2, kToastColor, context);
        return false;
      } else if (_degreePercentageController.text == '') {
        showToast('Please enter percentage scored for Degree', 2, kToastColor,
            context);
        return false;
      }
      return true;
    } else if (_preTrainingBoardController.text != '') {
      if (_preTrainingPassingController.text == '') {
        showToast('Please enter passing year for Pre Sea Training', 2,
            kToastColor, context);
        return false;
      } else if (_preTrainingPercentageController.text == '') {
        showToast('Please enter percentage scored for Pre Sea Training', 2,
            kToastColor, context);
        return false;
      }
      return true;
    } else if (_otherBoardController.text != '') {
      if (_otherPassingController.text == '') {
        showToast(
            'please enter passing year for Other', 2, kToastColor, context);
        return false;
      } else if (_otherPercentageController.text == '') {
        showToast('Please enter percentage scored for Other', 2, kToastColor,
            context);
        return false;
      }
      return true;
    } else {
      FocusScope.of(context).unfocus();
      print("Proceed");
      return true;
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
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFECEDF5),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'SSC',
                                      style: kvaccineTextStyle,
                                    ),
                                    IconButton(
                                      icon: isExpanded
                                          ? Icon(Icons.keyboard_arrow_down)
                                          : Icon(Icons.keyboard_arrow_up),
                                      onPressed: () {
                                        setState(() {
                                          isExpanded = !isExpanded;
                                        });
                                      },
                                      iconSize: 30, // Adjust the size as needed
                                      color: Colors
                                          .black, // Adjust the color as needed
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: texts.length,
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
                                              vertical: 14, horizontal: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: kLoginTextFieldFillColor,
                                          ),
                                          child: Row(children: [
                                            Icon(
                                                index == 0
                                                    ? Icons.school_outlined
                                                    : index == 1
                                                        ? Icons
                                                            .date_range_outlined
                                                        : Icons
                                                            .percent_outlined,
                                                size: 20,
                                                color: kLoginIconColor),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: TextFormField(
                                                keyboardType:
                                                    index == 1 || index == 2
                                                        ? TextInputType.number
                                                        : TextInputType.text,
                                                inputFormatters: index == 1
                                                    ? [
                                                        LengthLimitingTextInputFormatter(
                                                            4)
                                                      ]
                                                    : index == 2
                                                        ? [
                                                            LengthLimitingTextInputFormatter(
                                                                3)
                                                          ]
                                                        : [
                                                            LengthLimitingTextInputFormatter(
                                                                200)
                                                          ],
                                                controller: index == 0
                                                    ? _sscBoardController
                                                    : index == 2
                                                        ? _sscPercentageController
                                                        : _sscPassingController,
                                                onTapAlwaysCalled: true,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  // contentPadding:
                                                  //     EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                                  isDense: true,
                                                  hintText: '${texts[index]}',
                                                  hintStyle:
                                                      kLoginTextFieldTextStyle,
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    index == 0
                                                        ? _sscBoardController
                                                            .text = value
                                                        : index == 1
                                                            ? _sscPassingController
                                                                .text = value
                                                            : _sscPercentageController
                                                                .text = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        height: isExpanded ? 70 : 350,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      //Another HSC Degree
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFECEDF5),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'HSC',
                                      style: kvaccineTextStyle,
                                    ),
                                    IconButton(
                                      icon: isExpanded1
                                          ? Icon(Icons.keyboard_arrow_down)
                                          : Icon(Icons.keyboard_arrow_up),
                                      onPressed: () {
                                        setState(() {
                                          isExpanded1 = !isExpanded1;
                                        });
                                      },
                                      iconSize: 30, // Adjust the size as needed
                                      color: Colors
                                          .black, // Adjust the color as needed
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: texts.length,
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
                                              vertical: 14, horizontal: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: kLoginTextFieldFillColor,
                                          ),
                                          child: Row(children: [
                                            Icon(
                                                index == 0
                                                    ? Icons.school_outlined
                                                    : index == 1
                                                        ? Icons
                                                            .date_range_outlined
                                                        : Icons
                                                            .percent_outlined,
                                                size: 20,
                                                color: kLoginIconColor),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: TextFormField(
                                                keyboardType:
                                                    index == 1 || index == 2
                                                        ? TextInputType.number
                                                        : TextInputType.text,
                                                inputFormatters: index == 1
                                                    ? [
                                                        LengthLimitingTextInputFormatter(
                                                            4)
                                                      ]
                                                    : index == 2
                                                        ? [
                                                            LengthLimitingTextInputFormatter(
                                                                3)
                                                          ]
                                                        : [
                                                            LengthLimitingTextInputFormatter(
                                                                200)
                                                          ],
                                                controller: index == 0
                                                    ? _hscBoardController
                                                    : index == 2
                                                        ? _hscPercentageController
                                                        : _hscPassingController,
                                                onTapAlwaysCalled: true,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  // contentPadding:
                                                  //     EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                                  isDense: true,
                                                  hintText: '${texts[index]}',
                                                  hintStyle:
                                                      kLoginTextFieldTextStyle,
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    index == 0
                                                        ? _hscBoardController
                                                            .text = value
                                                        : index == 1
                                                            ? _hscPassingController
                                                                .text = value
                                                            : _hscPercentageController
                                                                .text = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        height: isExpanded1 ? 70 : 350,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      //Another Degree
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFECEDF5),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Degree',
                                      style: kvaccineTextStyle,
                                    ),
                                    IconButton(
                                      icon: isExpanded2
                                          ? Icon(Icons.keyboard_arrow_down)
                                          : Icon(Icons.keyboard_arrow_up),
                                      onPressed: () {
                                        setState(() {
                                          isExpanded2 = !isExpanded2;
                                        });
                                      },
                                      iconSize: 30, // Adjust the size as needed
                                      color: Colors
                                          .black, // Adjust the color as needed
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: texts.length,
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
                                              vertical: 14, horizontal: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: kLoginTextFieldFillColor,
                                          ),
                                          child: Row(children: [
                                            Icon(
                                                index == 0
                                                    ? Icons.school_outlined
                                                    : index == 1
                                                        ? Icons
                                                            .date_range_outlined
                                                        : Icons
                                                            .percent_outlined,
                                                size: 20,
                                                color: kLoginIconColor),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: TextFormField(
                                                keyboardType:
                                                    index == 1 || index == 2
                                                        ? TextInputType.number
                                                        : TextInputType.text,
                                                inputFormatters: index == 1
                                                    ? [
                                                        LengthLimitingTextInputFormatter(
                                                            4)
                                                      ]
                                                    : index == 2
                                                        ? [
                                                            LengthLimitingTextInputFormatter(
                                                                3)
                                                          ]
                                                        : [
                                                            LengthLimitingTextInputFormatter(
                                                                200)
                                                          ],
                                                controller: index == 0
                                                    ? _degreeBoardController
                                                    : index == 2
                                                        ? _degreePercentageController
                                                        : _degreePassingController,
                                                onTapAlwaysCalled: true,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  // contentPadding:
                                                  //     EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                                  isDense: true,
                                                  hintText: '${texts[index]}',
                                                  hintStyle:
                                                      kLoginTextFieldTextStyle,
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    index == 0
                                                        ? _degreeBoardController
                                                            .text = value
                                                        : index == 1
                                                            ? _degreePassingController
                                                                .text = value
                                                            : _degreePercentageController
                                                                .text = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        height: isExpanded2 ? 70 : 350,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      //Another degree Pre Sea Training
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFECEDF5),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Pre Sea Training',
                                      style: kvaccineTextStyle,
                                    ),
                                    IconButton(
                                      icon: isExpanded3
                                          ? Icon(Icons.keyboard_arrow_down)
                                          : Icon(Icons.keyboard_arrow_up),
                                      onPressed: () {
                                        setState(() {
                                          isExpanded3 = !isExpanded3;
                                        });
                                      },
                                      iconSize: 30, // Adjust the size as needed
                                      color: Colors
                                          .black, // Adjust the color as needed
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: texts.length,
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
                                              vertical: 14, horizontal: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: kLoginTextFieldFillColor,
                                          ),
                                          child: Row(children: [
                                            Icon(
                                                index == 0
                                                    ? Icons.school_outlined
                                                    : index == 1
                                                        ? Icons
                                                            .date_range_outlined
                                                        : Icons
                                                            .percent_outlined,
                                                size: 20,
                                                color: kLoginIconColor),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: TextFormField(
                                                keyboardType:
                                                    index == 1 || index == 2
                                                        ? TextInputType.number
                                                        : TextInputType.text,
                                                inputFormatters: index == 1
                                                    ? [
                                                        LengthLimitingTextInputFormatter(
                                                            4)
                                                      ]
                                                    : index == 2
                                                        ? [
                                                            LengthLimitingTextInputFormatter(
                                                                3)
                                                          ]
                                                        : [
                                                            LengthLimitingTextInputFormatter(
                                                                200)
                                                          ],
                                                controller: index == 0
                                                    ? _preTrainingBoardController
                                                    : index == 2
                                                        ? _preTrainingPercentageController
                                                        : _preTrainingPassingController,
                                                onTapAlwaysCalled: true,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  // contentPadding:
                                                  //     EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                                  isDense: true,
                                                  hintText: '${texts[index]}',
                                                  hintStyle:
                                                      kLoginTextFieldTextStyle,
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    index == 0
                                                        ? _preTrainingBoardController
                                                            .text = value
                                                        : index == 1
                                                            ? _preTrainingPassingController
                                                                .text = value
                                                            : _preTrainingPercentageController
                                                                .text = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        height: isExpanded3 ? 70 : 350,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      //Another other degree
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFECEDF5),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Other',
                                      style: kvaccineTextStyle,
                                    ),
                                    IconButton(
                                      icon: isExpanded4
                                          ? Icon(Icons.keyboard_arrow_down)
                                          : Icon(Icons.keyboard_arrow_up),
                                      onPressed: () {
                                        setState(() {
                                          isExpanded4 = !isExpanded4;
                                        });
                                      },
                                      iconSize: 30, // Adjust the size as needed
                                      color: Colors
                                          .black, // Adjust the color as needed
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: texts.length,
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
                                              vertical: 14, horizontal: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: kLoginTextFieldFillColor,
                                          ),
                                          child: Row(children: [
                                            Icon(
                                                index == 0
                                                    ? Icons.school_outlined
                                                    : index == 1
                                                        ? Icons
                                                            .date_range_outlined
                                                        : Icons
                                                            .percent_outlined,
                                                size: 20,
                                                color: kLoginIconColor),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: TextFormField(
                                                keyboardType:
                                                    index == 1 || index == 2
                                                        ? TextInputType.number
                                                        : TextInputType.text,
                                                inputFormatters: index == 1
                                                    ? [
                                                        LengthLimitingTextInputFormatter(
                                                            4)
                                                      ]
                                                    : index == 2
                                                        ? [
                                                            LengthLimitingTextInputFormatter(
                                                                3)
                                                          ]
                                                        : [
                                                            LengthLimitingTextInputFormatter(
                                                                200)
                                                          ],
                                                controller: index == 0
                                                    ? _otherBoardController
                                                    : index == 2
                                                        ? _otherPercentageController
                                                        : _otherPassingController,
                                                onTapAlwaysCalled: true,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  // contentPadding:
                                                  //     EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                                  isDense: true,
                                                  hintText: '${texts[index]}',
                                                  hintStyle:
                                                      kLoginTextFieldTextStyle,
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    index == 0
                                                        ? _otherBoardController
                                                            .text = value
                                                        : index == 1
                                                            ? _otherPassingController
                                                                .text = value
                                                            : _otherPercentageController
                                                                .text = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        height: isExpanded4 ? 70 : 350,
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
                          child: Text('Next', style: kButtonTextStyle),
                          onPressed: () {
                                  if (isValidForm()) {
                                    submitAcademicDetails();
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
        ));
  }
}
