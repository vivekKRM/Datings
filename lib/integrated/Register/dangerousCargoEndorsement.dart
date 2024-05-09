import 'package:Dating/constants/developer-styles.dart';
import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getCargo.dart';
import 'package:Dating/json/getCertificate.dart';
import 'package:Dating/json/getLevel.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DangerousCargoEndorsement extends StatefulWidget {
  DangerousCargoEndorsement(
      {Key? key,
      required this.title,
      required this.appManager,
      required this.updateBtn})
      : super(key: key);

  final String title;
  final AppManager appManager;
  final bool updateBtn;

  @override
  _DangerousCargoEndorsementState createState() =>
      _DangerousCargoEndorsementState();
}

class _DangerousCargoEndorsementState extends State<DangerousCargoEndorsement> {
  late FToast fToast;
  List<String> texts = [
    'Select Level',
    'Expiry Date',
  ];
  Map<String, dynamic> arguments = {
    'update': false,
    'index': '0',
    'add': false
  };
  String user_id = '';
  DateTime _selectedDate = DateTime.now();
  List<Levels> cargolevel = [];
  List<Result?> dangerous = [];
  bool isContainerTapped = false;
  bool islpgTapped = false;
  bool ischemicalTapped = false;
  String token = '';
  late SharedPreferences prefs;
  TextEditingController oillevelController = TextEditingController();
  TextEditingController _lpglevelController = TextEditingController();
  TextEditingController _checmicallevelController = TextEditingController();
  TextEditingController _oilExpiryController = TextEditingController();
  TextEditingController _lpgExpiryController = TextEditingController();
  TextEditingController _chemicalExpiryController = TextEditingController();

  List<Certificates> certificateType = [];
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
                      ? 'Your information has been updated successfully.'
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
                          : Navigator.pushNamed(context, "/seaexperience",
                              arguments: arguments);
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

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (pickedDate != null) {
      //&& pickedDate != _selectedDate
      setState(() {
        _selectedDate = pickedDate;
        String formattedDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
        type == "oil"
            ? _oilExpiryController.text = formattedDate
            : type == "lpg"
                ? _lpgExpiryController.text = formattedDate
                : _chemicalExpiryController.text = formattedDate;
      });
    }
  }

  Future<void> getLevel() async {
    final requestBody = {"": ''};
    widget.appManager.apis
        .getLevel(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        cargolevel = response.levels;
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to get level");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get level: $error");
    });
  }

  void _showDropdown(BuildContext context, String type) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: ListView.builder(
            itemCount: cargolevel.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  cargolevel[index].name,
                  style: kDropDownTextStyle,
                ),
                onTap: () {
                  setState(() {
                    if (type == "oil") {
                      setState(() {
                        isContainerTapped = true;
                      });
                      oillevelController.text = cargolevel[index].name;
                    } else if (type == "lpg") {
                      setState(() {
                        islpgTapped = true;
                      });
                      _lpglevelController.text = cargolevel[index].name;
                    } else {
                      setState(() {
                        ischemicalTapped = true;
                      });
                      _checmicallevelController.text = cargolevel[index].name;
                    }
                  });
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> submitCargoEndorementDetails() async {
    String user_id = prefs.getString('sId') ?? '';
    final requestBody = {
      'page': '6',
      'user_id': user_id,
      'dcen1': isContainerTapped ? 'oil tanker' : '',
      'level1': isContainerTapped ? oillevelController.text : '',
      'expiry1': isContainerTapped ? _oilExpiryController.text : '',
      'dcen2': islpgTapped ? 'lpg carrier' : '',
      'level2': islpgTapped ? _lpglevelController.text : '',
      'expiry2': islpgTapped ? _lpgExpiryController.text : '',
      'dcen3': ischemicalTapped ? 'chemical tanker' : '',
      'level3': ischemicalTapped ? _checmicallevelController.text : '',
      'expiry3': ischemicalTapped ? _chemicalExpiryController.text : '',
    };
    widget.appManager.apis
        .sendRegister(requestBody, (prefs.getString('authToken') ?? ''))
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

  Future<void> updateCargoEndorementDetails() async {
    String user_id = prefs.getString('sId') ?? '';
    final requestBody = {
      'page': '11',
      'user_id': user_id,
      'dcen1': isContainerTapped ? 'oil tanker' : '',
      'level1': isContainerTapped ? oillevelController.text : '',
      'expiry1': isContainerTapped ? _oilExpiryController.text : '',
      'dcen2': islpgTapped ? 'lpg carrier' : '',
      'level2': islpgTapped ? _lpglevelController.text : '',
      'expiry2': islpgTapped ? _lpgExpiryController.text : '',
      'dcen3': ischemicalTapped ? 'chemical tanker' : '',
      'level3': ischemicalTapped ? _checmicallevelController.text : '',
      'expiry3': ischemicalTapped ? _chemicalExpiryController.text : '',
    };
    widget.appManager.apis
        .updateDCE(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        // prefs.setString('sId', response?.user_id ?? '');
        _showCustomDialog(context);
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to update DCE");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to update DCE: $error");
    });
  }

  Future<void> getCargoEndorementDetails(String user_id) async {
    if (user_id != "") {
      final requestBody = {"user_id": user_id};
      widget.appManager.apis
          .getCargoEndorementDetails(
              requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            dangerous = response?.user ?? [];
            response?.user[0]?.tank1 != ""
                ? isContainerTapped = true
                : isContainerTapped = false;
            response?.user[0]?.tank2 != ""
                ? islpgTapped = true
                : islpgTapped = false;
            response?.user[0]?.tank3 != ""
                ? ischemicalTapped = true
                : ischemicalTapped = false;
            oillevelController.text = response?.user[0]?.level1 ?? '';
            _oilExpiryController.text = (response?.user[0]?.enddate1 ?? '') !=
                    "0000-00-00"
                ? widget.appManager.utils
                    .parseDate('dd-MMM-yyyy', response?.user[0]?.enddate1 ?? '')
                : '';
            _lpglevelController.text = response?.user[0]?.level2 ?? '';
            _lpgExpiryController.text = (response?.user[0]?.enddate2 ?? '') !=
                    "0000-00-00"
                ? widget.appManager.utils
                    .parseDate('dd-MMM-yyyy', response?.user[0]?.enddate2 ?? '')
                : '';
            _checmicallevelController.text = response?.user[0]?.level3 ?? '';
            _chemicalExpiryController.text =
                (response?.user[0]?.enddate3 ?? '') != "0000-00-00"
                    ? widget.appManager.utils.parseDate(
                        'dd-MMM-yyyy', response?.user[0]?.enddate3 ?? '')
                    : '';
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
          print("Failed to get profileExperience data");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to get profileExperience data: $error");
      });
    } else {
      showToast('Please get user_id', 2, kToastColor, context);
    }
  }

  bool isValidForm() {
    if (isContainerTapped) {
      if (oillevelController.text == '') {
        showToast('Please select level', 2, kToastColor, context);
        return false;
      } else if (_oilExpiryController.text == '') {
        showToast('Please enter oil expiry date', 2, kToastColor, context);
        return false;
      }
      return true;
    } else if (islpgTapped) {
      if (_lpglevelController.text == '') {
        showToast('Please lpg select level', 2, kToastColor, context);
        return false;
      } else if (_lpgExpiryController.text == '') {
        showToast('Please enter lpg expiry date', 2, kToastColor, context);
        return false;
      }
      return true;
    } else if (ischemicalTapped) {
      if (_checmicallevelController.text == '') {
        showToast('Please select chemical level', 2, kToastColor, context);
        return false;
      } else if (_chemicalExpiryController.text == '') {
        showToast('Please enter chemical expiry date', 2, kToastColor, context);
        return false;
      }
      return true;
    } else if (isContainerTapped == false ||
        islpgTapped == false ||
        ischemicalTapped == false) {
      showToast(
          'Please select a container to proceed with', 2, kToastColor, context);
      return false;
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
    user_id = prefs.getString('sId') ?? '';
    getLevel();
    widget.updateBtn ? getCargoEndorementDetails(user_id) : null;
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
              'Dangerous Cargo Endorsement',
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
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            // Toggle the color state
                            isContainerTapped = !isContainerTapped;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isContainerTapped
                                ? kButtonColor
                                : Color(0xFFECEDF5),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 9, bottom: 7),
                                  child: Text(
                                    'Oil Tanker',
                                    style: isContainerTapped
                                        ? kContainerColor
                                        : kvaccineTextStyle,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: texts.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7),
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
                                            child: Row(
                                              children: [
                                                Icon(
                                                    index == 0
                                                        ? Icons.oil_barrel
                                                        : Icons
                                                            .date_range_outlined,
                                                    size: 20,
                                                    color: kLoginIconColor),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: TextFormField(
                                                      readOnly: true,
                                                      controller: index == 0
                                                          ? oillevelController
                                                          : _oilExpiryController,
                                                      onTapAlwaysCalled: true,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                        hintText:
                                                            '${texts[index]}',
                                                        hintStyle:
                                                            kLoginTextFieldTextStyle,
                                                      ),
                                                      onTap: () {
                                                        index == 0
                                                            ? _showDropdown(
                                                                context, 'oil')
                                                            : isContainerTapped
                                                                ? _selectDate(
                                                                    context,
                                                                    'oil')
                                                                : showToast(
                                                                    'Please select the oil container first',
                                                                    2,
                                                                    kToastColor,
                                                                    context);
                                                      }),
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
                          height: 250,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      //Another HSC Degree
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            // Toggle the color state
                            islpgTapped = !islpgTapped;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                islpgTapped ? kbuttonColor : Color(0xFFECEDF5),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 9, bottom: 7),
                                  child: Text(
                                    'LPG Carrier',
                                    style: islpgTapped
                                        ? kContainerColor
                                        : kvaccineTextStyle,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: texts.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7),
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
                                                      ? Icons.propane_tank
                                                      : Icons
                                                          .date_range_outlined,
                                                  size: 20,
                                                  color: kLoginIconColor),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: TextFormField(
                                                  readOnly: true,
                                                  controller: index == 0
                                                      ? _lpglevelController
                                                      : _lpgExpiryController,
                                                  onTapAlwaysCalled: true,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    isDense: true,
                                                    hintText: '${texts[index]}',
                                                    hintStyle:
                                                        kLoginTextFieldTextStyle,
                                                  ),
                                                  onTap: () {
                                                    index == 0
                                                        ? _showDropdown(
                                                            context, 'lpg')
                                                        : islpgTapped
                                                            ? _selectDate(
                                                                context, 'lpg')
                                                            : showToast(
                                                                'Please select the lpg container first',
                                                                2,
                                                                kToastColor,
                                                                context);
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
                          height: 250,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      //Another Degree
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            // Toggle the color state
                            ischemicalTapped = !ischemicalTapped;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 9, bottom: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ischemicalTapped
                                ? kbuttonColor
                                : Color(0xFFECEDF5),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 9, bottom: 7),
                                  child: Text(
                                    'Chemical Tanker',
                                    style: ischemicalTapped
                                        ? kContainerColor
                                        : kvaccineTextStyle,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: texts.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7),
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
                                                      ? Icons.propane
                                                      : Icons
                                                          .date_range_outlined,
                                                  size: 20,
                                                  color: kLoginIconColor),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: TextFormField(
                                                  readOnly: true,
                                                  controller: index == 0
                                                      ? _checmicallevelController
                                                      : _chemicalExpiryController,
                                                  onTapAlwaysCalled: true,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    isDense: true,
                                                    hintText: '${texts[index]}',
                                                    hintStyle:
                                                        kLoginTextFieldTextStyle,
                                                  ),
                                                  onTap: () {
                                                    index == 0
                                                        ? _showDropdown(
                                                            context, 'chemical')
                                                        : ischemicalTapped
                                                            ? _selectDate(
                                                                context,
                                                                'chemical')
                                                            : showToast(
                                                                'Please select the chemical container first',
                                                                2,
                                                                kToastColor,
                                                                context);
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
                          height: 250,
                        ),
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
                            if (isValidForm()) {
                              widget.updateBtn
                                  ? updateCargoEndorementDetails()
                                  : submitCargoEndorementDetails();
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
