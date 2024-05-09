import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getCertificate.dart';
import 'package:Dating/json/getCertificateCompetency.dart';
import 'package:Dating/json/getCountry.dart';
import 'package:Dating/json/getNationality.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CertificationOfCompetency extends StatefulWidget {
  CertificationOfCompetency(
      {Key? key,
      required this.title,
      required this.appManager,
      required this.updateBtn})
      : super(key: key);

  final String title;
  final AppManager appManager;
  final Map<String, dynamic> updateBtn;

  @override
  _CertificationOfCompetencyState createState() =>
      _CertificationOfCompetencyState();
}

class _CertificationOfCompetencyState extends State<CertificationOfCompetency> {
  late FToast fToast;
  String certificateTypes = '';
  List<String> texts = [
    'Certificate Type',
    'Certificate Number',
    'Issuing Authority',
    'Issue Date',
    'Expiry Date',
    'Indos Number',
  ];
  List<Result?> certificate = [];
  String token = '';
  String user_id = '';
  bool update = false;
  bool add = false;
  String index = '';
  late SharedPreferences prefs;
  TextEditingController _certificateTypeController = TextEditingController();
  TextEditingController _certificateNumberController = TextEditingController();
  TextEditingController _issueAuthController = TextEditingController();
  TextEditingController _issueDateController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _indosNoController = TextEditingController();
  TextEditingController _otherissueAuthController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  List<Nationality> _nationalityoptions = [];
  List<Certificates> certificateType = [];

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: type == 'Expiry date' ? DateTime(2200) : DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
         String formattedDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
        type == 'Expiry date'
            ? _expiryDateController.text = formattedDate
            : _issueDateController.text = formattedDate;
      });
    }
  }

  Future<void> getCertificate() async {
    prefs = await SharedPreferences.getInstance();
    final requestBody = {"": ''};
    widget.appManager.apis
        .getCertificate(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        certificateType = response.certificates;

        //  Navigator.pushReplacementNamed(context, '/login');
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to get country");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get country: $error");
    });
  }

  Future<void> getCertificateDetail(String user_id) async {
    if (index != "") {
      final requestBody = {"seajob_id": index};
      widget.appManager.apis
          .getSingleCertificateCompetency(
              requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            certificate = response?.user ?? [];
            certificateTypes = certificate[0]?.certificatetype ?? '';
            _certificateNumberController.text =
                certificate[0]?.certificatenumber ?? '';
            _certificateTypeController.text =
                certificate[0]?.certificatename ?? '';
            _issueAuthController.text = certificate[0]?.issueauth ?? '';
            _issueDateController.text = certificate[0]?.issuedate ?? '';
            _expiryDateController.text = certificate[0]?.expirydate ?? '';
            _indosNoController.text = certificate[0]?.indosnu ?? '';
            _otherissueAuthController.text =
                certificate[0]?.otherissueauth ?? '';
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
          print("Failed to get certificate data");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to get certificate data: $error");
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

  void _showDropdown(BuildContext context, String type) {
    TextEditingController searchController = TextEditingController();
    List<dynamic> filteredAuthority = List.from(_nationalityoptions);

    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
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
                        hintText: "Search nationalities...",
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredAuthority = _nationalityoptions
                              .where((element) => element.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredAuthority.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            filteredAuthority[index].name,
                            style: kDropDownTextStyle,
                          ),
                          onTap: () {
                            setState(() {
                              _issueAuthController.text =
                                  filteredAuthority[index].name;
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

//Added new
  void _showDropdownm(BuildContext context, String type) {
    TextEditingController searchController = TextEditingController();
    List<dynamic> filteredAuthority = List.from(certificateType);

    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
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
                        hintText: "Search certificates...",
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredAuthority = certificateType
                              .where((element) => element.certificate_name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredAuthority.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            filteredAuthority[index].certificate_name,
                            style: kDropDownTextStyle,
                          ),
                          onTap: () {
                            setState(() {
                              certificateTypes = certificateType[index].seajob_id;
                              _certificateTypeController.text =
                                  filteredAuthority[index].certificate_name;
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
//Added new

  void _showCustomDialog(BuildContext context,int status) {
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
                  // update == true
                  //     ? "Your information has been updated successfully."
                  //     : add == true
                  //         ? "Your information has been added successfully."
                  //         : 'Your information has been submitted successfully.',
                  update == true
                      ? "Your information has been updated successfully."
                      : add == true && status == 0
                          ? "Your information has been added successfully."
                      : status == 1 ? 
                            "Certification Of Competency already saved."
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
                      update == true || add == true
                          ? Navigator.pop(context)
                          : Navigator.pushNamed(context, "/academic",
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

  Future<void> submitCompetencyDetails() async {
    String user_id = prefs.getString('sId') ?? '';
    final requestBody = {
      'page': update ? '13' : '5',
      'user_id': user_id,
      'certificatetype': certificateTypes,
      'certificateno': _certificateNumberController.text,
      'authorityissue': _issueAuthController.text,
      'issue': _issueDateController.text,
      'expiry': _expiryDateController.text,
      'indosno': _indosNoController.text,
      'OtherIssuingAuthority': _otherissueAuthController.text,
    };
    if (update) {
      requestBody['edit'] = 'e';
      requestBody['cert_id'] = index;
    } else if (add) {
      // requestBody['more'] = index;
    } else {
      requestBody['edu1'] = '';
      requestBody['board1'] = '';
      requestBody['year1'] = '';
      requestBody['percentage1'] = '';
      requestBody['edu2'] = '';
      requestBody['board2'] = '';
      requestBody['year2'] = '';
      requestBody['percentage2'] = '';
      requestBody['edu3'] = '';
      requestBody['board3'] = '';
      requestBody['year3'] = '';
      requestBody['percentage3'] = '';
      requestBody['edu4'] = '';
      requestBody['board4'] = '';
      requestBody['year4'] = '';
      requestBody['percentage4'] = '';
      requestBody['edu5'] = '';
      requestBody['board5'] = '';
      requestBody['year5'] = '';
      requestBody['percentage5'] = '';
    }
    widget.appManager.apis
        .sendRegister(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        // prefs.setString('sId', response?.user_id ?? '');
        // _showCustomDialog(context);
          if((response?.message ?? '').contains('already') && (add == true)){
            // _showCustomDialog(context, 1);
        }else{
          _showCustomDialog(context, 0);
        }
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to submit certificate");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to submit certificate: $error");
    });
  }

  bool isValidForm() {
    if (_certificateTypeController.text == '') {
      showToast('Please select certificate type', 2, kToastColor, context);
      return false;
    } else if (_certificateNumberController.text == '') {
      showToast('Please enter certificate number', 2, kToastColor, context);
      return false;
    } else if (_issueAuthController.text == '') {
      showToast('Please select issuing authority', 2, kToastColor, context);
      return false;
    } else if (_issueDateController.text == '') {
      showToast('Please select issuing date', 2, kToastColor, context);
      return false;
    } else if (_expiryDateController.text == '') {
      showToast('Please select expiry date', 2, kToastColor, context);
      return false;
    } else if (_issueDateController.text == _expiryDateController.text) {
      showToast(
          'Issue date and expiry date cannot be same', 2, kToastColor, context);
      return false;
    } else if (_indosNoController.text == '') {
      showToast('Please enter Indos number', 2, kToastColor, context);
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
    update = widget.updateBtn['update'] as bool;
    index = widget.updateBtn['index'] as String;
    add = widget.updateBtn['add'] as bool;
    update ? getCertificateDetail(user_id) : null;
    getCertificate();
    getNationality();
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
              'Certification Of Competency',
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
                          shrinkWrap: true,
                          itemCount: texts.length,
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
                                        vertical: 14, horizontal: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          index == 0
                                              ? Icons.document_scanner_outlined
                                              : index == 1
                                                  ? Icons.numbers_outlined
                                                  : index == 2
                                                      ? Icons.person_2_outlined
                                                      : index == 5
                                                          ? Icons
                                                              .numbers_outlined
                                                          : Icons
                                                              .calendar_month_outlined,
                                          size: 20,
                                          color: kLoginIconColor,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            readOnly: index == 0 ||
                                                    index == 2 ||
                                                    index == 3 ||
                                                    index == 4
                                                ? true
                                                : false,
                                            controller: index == 0
                                                ? _certificateTypeController
                                                : index == 1
                                                    ? _certificateNumberController
                                                    : index == 2
                                                        ? _issueAuthController
                                                        : index == 3
                                                            ? _issueDateController
                                                            : index == 4
                                                                ? _expiryDateController
                                                                : _indosNoController,
                                            onTapAlwaysCalled: true,
                                            inputFormatters: index == 5
                                                ? [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'[a-zA-Z0-9]')), // Allow letters and numbers
                                                    LengthLimitingTextInputFormatter(
                                                        10), // Limit the input to 12 characters
                                                  ]
                                                : [
                                                    LengthLimitingTextInputFormatter(
                                                        200)
                                                  ],
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
                                                    ? _certificateNumberController
                                                        .text = value
                                                    : index == 5
                                                        ? _indosNoController
                                                            .text = value
                                                        : null;
                                              });
                                            },
                                            onTap: () {
                                              index == 0
                                                  ? _showDropdownm(
                                                      context, 'Certificate')
                                                  : index == 2
                                                      ? _showDropdown(context,
                                                          'Nationality')
                                                      : index == 3
                                                          ? _selectDate(context,
                                                              'Issue date')
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
                                  // Add the condition here
                                  if (index == 2 &&
                                      _issueAuthController.text == 'OTHER')
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 12),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .person_2_outlined, // You can replace this with your desired icon
                                              size: 20,
                                              color: kLoginIconColor,
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                controller:
                                                    _otherissueAuthController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                  hintText:
                                                      'Other Issuing Authority',
                                                  hintStyle:
                                                      kLoginTextFieldTextStyle,
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _otherissueAuthController
                                                        .text = value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                        // height: 700,
                      ),
                      Container(
                        width: size.width,
                        height: 65,
                        margin: EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: kButtonColor,
                          ),
                          child: Text(
                              update
                                  ? 'Update'
                                  : add
                                      ? 'Add'
                                      : 'Next',
                              style: kButtonTextStyle),
                          onPressed: () {
                                  if (isValidForm()) {
                                    submitCompetencyDetails();
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
