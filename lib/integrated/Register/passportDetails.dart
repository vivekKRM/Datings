import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getNationality.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class PassportDetails extends StatefulWidget {
  PassportDetails(
      {Key? key,
      required this.title,
      required this.appManager,
      required this.updateBtn})
      : super(key: key);

  final String title;
  final AppManager appManager;
  final bool updateBtn;

  @override
  _PassportDetailsState createState() => _PassportDetailsState();
}

class _PassportDetailsState extends State<PassportDetails> {
  late FToast fToast;
  List<String> texts = [
    'Nationality',
    'Passport Number',
    'Place of Issue',
    'Date of Issue',
    'Expiry Date',
  ];
  List<String> stexts = [
    'US VISA',
    'Any Other',
    'Issue Date',
    'Expiry Date',
  ];

  Map<String, dynamic> arguments = {
    'update': false,
    'index': '0',
    'add': false,
  };
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _passportController = TextEditingController();
  TextEditingController _placeofissueController = TextEditingController();
  TextEditingController _dateofissueController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _usVisaController = TextEditingController();
  TextEditingController _otherController = TextEditingController();
  TextEditingController _visaexpiryDateController = TextEditingController();
  TextEditingController _issueDateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  late SharedPreferences prefs;
  late List<Nationality> _nationalityoptions;
  List<String> _visaoptions = ['YES', 'NO'];
  String token = '';
  String user_id = '';
  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        String formattedDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
        type == "Date of issue"
            ? _dateofissueController.text = formattedDate
            : type == "Expiry date"
                ? _expiryDateController.text = formattedDate
                : type == "Visa expiry date"
                    ? _visaexpiryDateController.text = formattedDate
                    : _issueDateController.text = formattedDate;
      });
    }
  }

  void _showDropdown(BuildContext context, String type) {
    List<dynamic> options;
    String placeholder;
    if (type == "VISA") {
      FocusScope.of(context).unfocus();
      options = _visaoptions;
      placeholder = 'Search visa...';
    } else {
      options = _nationalityoptions.map((option) => option.name).toList();
      placeholder = 'Search nationality...';
    }

    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        TextEditingController searchController = TextEditingController();

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: placeholder,
                      ),
                      onChanged: (value) {
                        setState(() {}); // Trigger rebuild on text change
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final String optionName =
                            type == "VISA" ? option : option;
                        // Check if the option matches the search query
                        final bool matchesSearch = optionName
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase());
                        // Show item only if it matches search query
                        if (!matchesSearch) return SizedBox.shrink();
                        return ListTile(
                          title: Text(
                            optionName,
                            style: kDropDownTextStyle,
                          ),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              type == "VISA"
                                  ? _usVisaController.text = option
                                  : _nationalityController.text = option;
                              _usVisaController.text == "NO"
                                  ? stexts = [
                                      'US VISA',
                                    ]
                                  : stexts = [
                                      'US VISA',
                                      'Any Other',
                                      'Issue Date',
                                      'Expiry Date',
                                    ];
                            });
                            Navigator.of(context).pop();
                          
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> submitPassportDetails() async {
    String user_id = prefs.getString('sId') ?? '';
    String user_name = prefs.getString('username') ?? '';
    final requestBody = {
      'page': '3',
      'user_id': user_id,
      'usvisa': _usVisaController.text,
      'nationality': _nationalityController.text,
      'passport': _passportController.text,
      'issueplace': _placeofissueController.text,
      'issuedateus': _visaexpiryDateController.text,
      'expirydateus': _issueDateController.text,
      'issuedate': _dateofissueController.text,
      'expirydate': _expiryDateController.text,
      'other': _otherController.text,
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
        print("Failed to submit passport details");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to submit passport details: $error");
    });
  }

  Future<void> updatePassportDetails() async {
    String user_id = prefs.getString('sId') ?? '';
    String user_name = prefs.getString('username') ?? '';
    final requestBody = {
      'page': '3',
      'user_id': user_id,
      'usvisa': _usVisaController.text,
      'nationality': _nationalityController.text,
      'passport': _passportController.text,
      'issueplace': _placeofissueController.text,
      'issuedateus': _visaexpiryDateController.text,
      'expirydateus': _issueDateController.text,
      'issuedate': _dateofissueController.text,
      'expirydate': _expiryDateController.text,
      'other': _otherController.text,
      'edit': 'e',
    };
    widget.appManager.apis
        .updateRegister(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        // prefs.setString('sId', response?.user_id ?? '');
        _showCustomDialog(context);
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to submit passport details");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to submit passport details: $error");
    });
  }

  Future<void> getPassportDetails(String user_id) async {
    if (user_id != "") {
      final requestBody = {"user_id": user_id};
      widget.appManager.apis
          .getPassport(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // prefs.setString('sId', response?.user?.id ?? '');
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            _nationalityController.text = response?.user?.nationality ?? '';
            _passportController.text = response?.user?.passportno ?? '';
            _placeofissueController.text = response?.user?.authority ?? '';
            _dateofissueController.text = widget.appManager.utils
                .parseDate('dd-MMM-yyyy', response?.user?.issuedate ?? '');
            _expiryDateController.text = widget.appManager.utils
                .parseDate('dd-MMM-yyyy', response?.user?.expirydate ?? '');
            _usVisaController.text =
                (response?.user?.usvisastatus ?? '').toUpperCase();
            _visaexpiryDateController.text =
                (response?.user?.usissuedate ?? '') == ''
                    ? widget.appManager.utils.parseDate(
                        'dd-MMM-yyyy', response?.user?.othervisaissuedate ?? '')
                    : widget.appManager.utils.parseDate(
                        'dd-MMM-yyyy', response?.user?.usissuedate ?? '');

            // (response?.user?.usvisastatus ?? '') == 'Yes'
            //     ? (response?.user?.usissuedate ?? '')
            //     : (response?.user?.othervisaissuedate ?? '');
            _issueDateController.text = (response?.user?.usexpirydate ?? '') ==
                    ''
                ? widget.appManager.utils.parseDate(
                    'dd-MMM-yyyy', response?.user?.othervisaexpirydate ?? '')
                : widget.appManager.utils.parseDate(
                    'dd-MMM-yyyy', response?.user?.usexpirydate ?? '');
            // (response?.user?.usvisastatus ?? '') == 'Yes'
            //     ? response?.user?.usexpirydate ?? ''
            //     : response?.user?.othervisaexpirydate ?? '';
            _otherController.text = response?.user?.othervisa ?? '';
            stexts.clear();
            _usVisaController.text == "NO"
                ? stexts = [
                    'US VISA',
                  ]
                : stexts = [
                    'US VISA',
                    'Any Other',
                    'Issue Date',
                    'Expiry Date',
                  ];
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
          print("Failed to get passport data");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to get passport data: $error");
      });
    } else {
      showToast('Please get user_id', 2, kToastColor, context);
    }
  }

  Future<void> getNationality() async {
    prefs = await SharedPreferences.getInstance();
    final requestBody = {"": ''};
    widget.appManager.apis
        .getNationality(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        _nationalityoptions = response.nationality;
        //  Navigator.pushReplacementNamed(context, '/login');
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to get nationality");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get nationality: $error");
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
                          : Navigator.pushNamed(context, "/seaman",
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

  bool isValidForm() {
    if (_nationalityController.text == '') {
      showToast('Please select nationality', 2, kToastColor, context);
      return false;
    } else if (_passportController.text == '') {
      showToast('Please enter passport number', 2, kToastColor, context);
      return false;
    } else if (_placeofissueController.text == '') {
      showToast(
          'please enter place of issue of passport', 2, kToastColor, context);
      return false;
    } else if (_dateofissueController.text == '') {
      showToast('Please select passport issue date', 2, kToastColor, context);
      return false;
    } else if (_expiryDateController.text == '') {
      showToast('Please select passport expiry date', 2, kToastColor, context);
      return false;
    } else if (_dateofissueController.text == _expiryDateController.text) {
      showToast(
          'please select expiry date and issue date of passport different',
          2,
          kToastColor,
          context);
      return false;
    } else if (_usVisaController.text == '') {
      showToast('Please select option', 2, kToastColor, context);
      return false;
    // } else if (_otherController.text == '' && _usVisaController.text == 'NO') {
    //   showToast('Please enter other option', 2, kToastColor, context);
    //   return false;
    } else if (_visaexpiryDateController.text.length < 6 && _usVisaController.text == 'YES') {
      showToast('Please select visa expiry date', 2, kToastColor, context);
      return false;
    } else if (_issueDateController.text.length < 6 && _usVisaController.text == 'YES') {
      showToast('Please select visa issue date', 2, kToastColor, context);
      return false;
    } else if (_issueDateController.text == _visaexpiryDateController.text && _usVisaController.text == 'YES') {
      showToast('Please select expiry date and issue date of visa different', 2,
          kToastColor, context);
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
    _nationalityoptions = [];
    getPrefs();
    getNationality();
    fToast = FToast();
    fToast.init(context);
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('authToken') ?? '';
    user_id = prefs.getString('sId') ?? '';
    widget.updateBtn ? getPassportDetails(user_id) : null;
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
              'Travel Documentation',
              style: kHeaderTextStyle,
            ),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              // Call your function here when scroll is updated
               FocusScope.of(context).unfocus();
            }
            return true; // Return true to continue handling the notification
          },
            child: SingleChildScrollView(
              child: Container(
                color: backgroundColor,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
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
                                child: Text(
                                  'Passport Details',
                                  style: kvaccineTextStyle,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                // scrollDirection: Axis.vertical,
                                itemCount: texts
                                    .length, // Change this number as per your requirement
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
                                          child: Row(
                                            children: [
                                              Icon(
                                                  index == 0
                                                      ? Icons.map_outlined
                                                      : index == 1
                                                          ? Icons.dock_outlined
                                                          : index == 2
                                                              ? Icons
                                                                  .house_outlined
                                                              : Icons
                                                                  .calendar_month_outlined,
                                                  size: 20,
                                                  color: kLoginIconColor),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: TextFormField(
                                                  keyboardType: index == 1
                                                      ? TextInputType.text
                                                      : TextInputType.text,
                                                  inputFormatters: index == 1
                                                      ? [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  r'[a-zA-Z0-9]')), // Allow letters and numbers
                                                          LengthLimitingTextInputFormatter(
                                                              12), // Limit the input to 12 characters
                                                        ]
                                                      : [
                                                          LengthLimitingTextInputFormatter(
                                                              200)
                                                        ],
                                                  readOnly: index == 0 ||
                                                          index == 3 ||
                                                          index == 4
                                                      ? true
                                                      : false,
                                                  controller: index == 0
                                                      ? _nationalityController
                                                      : index == 1
                                                          ? _passportController
                                                          : index == 2
                                                              ? _placeofissueController
                                                              : index == 3
                                                                  ? _dateofissueController
                                                                  : index == 4
                                                                      ? _expiryDateController
                                                                      : null,
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
                                                      index == 1
                                                          ? _passportController
                                                              .text = value
                                                          : index == 2
                                                              ? _placeofissueController
                                                                  .text = value
                                                              : null;
                                                    });
                                                  },
                                                  onTap: () {
                                                    index == 0
                                                        ? _showDropdown(context,
                                                            'Nationality')
                                                        : index == 3
                                                            ? _selectDate(
                                                                context,
                                                                'Date of issue')
                                                            : index == 4
                                                                ? _selectDate(
                                                                    context,
                                                                    'Expiry date')
                                                                : null;
                                                  },
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
                        height: 530,
                      ),

                      SizedBox(
                        height: 25,
                      ),
                      //VISA DETAILS
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
                                  child: Text(
                                    'Visa Details',
                                    style: kvaccineTextStyle,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: stexts.length,
                                  itemBuilder: (context, index) {
                                    if (index == 1 &&
                                        _usVisaController.text == "YES") {
                                      return SizedBox
                                          .shrink(); // Skip the text field for "Any Other"
                                    }
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
                                                      ? Icons
                                                          .document_scanner_outlined
                                                      : index == 2 || index == 3
                                                          ? Icons
                                                              .calendar_month_outlined
                                                          : Icons.dock_outlined,
                                                  size: 20,
                                                  color: kLoginIconColor),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: TextFormField(
                                                  readOnly: index == 0 ||
                                                          index == 2 ||
                                                          index == 3
                                                      ? true
                                                      : false,
                                                  controller: index == 0
                                                      ? _usVisaController
                                                      : index == 2
                                                          ? _visaexpiryDateController
                                                          : index == 1 &&
                                                                  _usVisaController
                                                                          .text ==
                                                                      "NO"
                                                              ? _otherController
                                                              : _issueDateController,
                                                  onTapAlwaysCalled: true,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    // contentPadding:
                                                    //     EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                                                    isDense: true,
                                                    hintText:
                                                        '${stexts[index]}',
                                                    hintStyle:
                                                        kLoginTextFieldTextStyle,
                                                  ),
                                                  onTap: () {
                                                   FocusScope.of(context).unfocus();
                                                    index == 0
                                                        ? _showDropdown(
                                                            context, 'VISA')
                                                        : index == 2
                                                            ? _selectDate(
                                                                context,
                                                                'Visa expiry date')
                                                            : index == 3
                                                                ? _selectDate(
                                                                    context,
                                                                    'date')
                                                                : null;
                                                  },
                                                  // onChanged: (value) {
                                                  //   setState(() {
                                                  //     index == 1 &&
                                                  //             _usVisaController
                                                  //                     .text ==
                                                  //                 "NO"
                                                  //         ? _otherController
                                                  //             .text = value
                                                  //         : null;
                                                  //   });
                                                  // },
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
                          height: _usVisaController.text == "YES" ? 340 : 150),

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
                                  ? updatePassportDetails()
                                  : submitPassportDetails();
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
        ));
  }
}


class ScreenState extends ChangeNotifier {
  // Add any state variables here
  String selectedOption = '';

  // Method to update the selected option
  void updateSelectedOption(String option) {
    selectedOption = option;
    notifyListeners();
  }
}