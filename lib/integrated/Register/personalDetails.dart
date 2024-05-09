import 'package:Dating/constants/styles.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PersonalDetails extends StatefulWidget {
  PersonalDetails({Key? key, required this.title, required this.appManager})
      : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  String email = '';
  String password = '';
  String token = '';
  bool loginError = false;
  bool obscureText = true;
  bool obscureText1 = true;
  late FToast fToast;
  late SharedPreferences prefs;
  List<String> texts = [
    'UserName',
    'Password',
    'Confirm Password',
    'First Name',
    'Middle Name',
    'SurName',
    'Date of Birth',
    'Gender',
    'Marital Status'
  ];
  DateTime _selectedDate = DateTime(2008, 12, 30);
  TextEditingController _dateController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _maritalController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cpasswordController = TextEditingController();
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _mnameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _firstDoseController = TextEditingController();
  TextEditingController _secondDoseController = TextEditingController();
  TextEditingController _boostDoseController = TextEditingController();

  List<String> _genderoptions = ['Male', 'Female'];
  List<String> _maritaloptions = ['Married', 'Unmarried'];

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: type == "DOB" ? _selectedDate : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: type == "DOB" ? DateTime(2008, 12, 30) : DateTime.now(),
    );
    if (pickedDate != null) {
      final age = DateTime.now().year - pickedDate.year;
      if (age >= 16 && type == "DOB") {
        setState(() {
          _selectedDate = pickedDate;
          String formattedDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
          _dateController.text = formattedDate;
        });
      } else if (type != "DOB") {
        setState(() {
          _selectedDate = pickedDate;
          String formattedDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
          type == "1"
              ? _firstDoseController.text = formattedDate
              : type == "2"
                  ? _secondDoseController.text = formattedDate
                  : _boostDoseController.text = formattedDate;
        });
      } else {
        showToast('Age must be 16 years or above.', 5, kToastColor, context);
      }
    }
  }

  void _showDropdown(BuildContext context, String type) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          // height: 200,
          child: ListView.builder(
            itemCount: type == 'Gender'
                ? _genderoptions.length
                : _maritaloptions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  type == 'Gender'
                      ? _genderoptions[index]
                      : _maritaloptions[index],
                  style: kDropDownTextStyle,
                ),
                onTap: () {
                  setState(() {
                    type == 'Gender'
                        ? _genderController.text = _genderoptions[index]
                        : _maritalController.text = _maritaloptions[index];
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

  Future<void> submitPersonalDetails() async {
    final requestBody = {
      'page': '1b',
      'username': _usernameController.text,
      'password': _passwordController.text,
      'merital': _maritalController.text,
      'gender': _genderController.text,
      'first': _fnameController.text,
      'middle': _mnameController.text,
      'sur': _surnameController.text,
      'dateofbirth': _dateController.text,
      'vdate1': _firstDoseController.text,
      'vdate2': _secondDoseController.text,
      'vname': _nameController.text,
      'vdate3': _boostDoseController.text,
    };
    print(requestBody);
    widget.appManager.apis
        .sendRegister(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        // showToast(response?.message ?? '', 2, kToastColor);
        prefs.setString('sId', response?.user_id ?? '');
        prefs.setString('username', _usernameController.text ?? '');
        _showCustomDialog(context);
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
        // showCustomAlertDialog('Warning', response?.message ?? '');
      } else {
        print("Failed to register");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to register: $error");
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
                      Navigator.pushNamed(context, "/contact",
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

  bool isValidForm() {
    // Email regex pattern
    final emailPattern = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (_usernameController.text == '') {
      showToast('Please enter username', 2, kToastColor, context);
      return false;
    } else if (_passwordController.text == '') {
      showToast('Please enter password', 2, kToastColor, context);
      return false;
    } else if (_passwordController.text.contains(' ')) {
      showToast('Password cannot contain spaces', 2, kToastColor, context);
      return false;
    } else if (_passwordController.text.length < 6) {
      showToast('Please enter strong password', 2, kToastColor, context);
      return false;
    } else if (_cpasswordController.text == '') {
      showToast('Please enter confirm password', 2, kToastColor, context);
      return false;
    } else if (_cpasswordController.text.contains(' ')) {
      showToast(
          'Confirm password cannot contain spaces', 2, kToastColor, context);
      return false;
    } else if (_cpasswordController.text.length < 6) {
      showToast(
          'please enter strong confirm password', 2, kToastColor, context);
      return false;
    } else if (_passwordController.text != _cpasswordController.text) {
      showToast('Please match password and  confirm password', 2, kToastColor,
          context);
      return false;
    } else if (_fnameController.text == '') {
      showToast('Please enter first name', 2, kToastColor, context);
      return false;
    } else if (_surnameController.text == '') {
      showToast('Please enter surname', 2, kToastColor, context);
      return false;
    } else if (_fnameController.text == '') {
      showToast('Please enter first name', 2, kToastColor, context);
      return false;
    } else if (_dateController.text == '') {
      showToast('Please select date of birth', 2, kToastColor, context);
      return false;
    } else if (_genderController.text == '') {
      showToast('Please select gender', 2, kToastColor, context);
      return false;
    } else if (_maritalController.text == '') {
      showToast('Please select marital status', 2, kToastColor, context);
      return false;
      // }else if(_nameController.text == ''){
      //     showToast('Please enter covid vaccine name', 2, kToastColor);
      //       return false;
      // }else if(_firstDoseController.text == ''){
      //     showToast('Please select covid dosage 1 date', 2, kToastColor);
      //       return false;
      // }else if(_secondDoseController.text == ''){
      //     showToast('Please select covid dosage 2 date', 2, kToastColor);
      //       return false;
      // }else if(_boostDoseController.text == ''){
      //     showToast('Please select covid booster dosage date', 2, kToastColor);
      //       return false;
    } else {
      print("Proceed");
      FocusScope.of(context).unfocus();
      return true;
    }
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
    fToast = FToast();
    getPrefs();
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
            backgroundColor: topHeaderBar,//kAppBarColor
            surfaceTintColor: topHeaderBar,//kAppBarColor
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Personal Details',
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width,
                      height: 220,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        child: Image.asset(
                          'assets/ship.gif',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Create an Account', style: kLoginTextStyle),
                          SizedBox(height: 20),
                          Text(
                            "Create your account to get started .",
                            style: kObsText,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 42),
                          Container(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              // scrollDirection: Axis.vertical,
                              itemCount: texts
                                  .length, // Change this number as per your requirement
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 15),
                                        //  margin: EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: kLoginTextFieldFillColor,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                                index == 0 ||
                                                        index == 3 ||
                                                        index == 4 ||
                                                        index == 5 ||
                                                        index == 7 ||
                                                        index == 8
                                                    ? Icons.person_4_outlined
                                                    : index == 1 || index == 2
                                                        ? Icons
                                                            .lock_open_outlined
                                                        : Icons
                                                            .calendar_month_outlined,
                                                size: 20,
                                                color: kLoginIconColor),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: TextFormField(
                                                inputFormatters: index == 3 ||
                                                        index == 4 ||
                                                        index == 5
                                                    ? [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r'[a-zA-Z]'))
                                                      ]
                                                    : [
                                                        LengthLimitingTextInputFormatter(
                                                            200)
                                                      ],
                                                readOnly: index == 6 ||
                                                        index == 7 ||
                                                        index == 8
                                                    ? true
                                                    : false,
                                                controller: index == 6
                                                    ? _dateController
                                                    : index == 7
                                                        ? _genderController
                                                        : index == 8
                                                            ? _maritalController
                                                            : index == 0
                                                                ? _usernameController
                                                                : index == 1
                                                                    ? _passwordController
                                                                    : index == 2
                                                                        ? _cpasswordController
                                                                        : index ==
                                                                                3
                                                                            ? _fnameController
                                                                            : index == 4
                                                                                ? _mnameController
                                                                                : index == 5
                                                                                    ? _surnameController
                                                                                    : null,
                                                obscureText: index == 1
                                                    ? obscureText
                                                    : index == 2
                                                        ? obscureText1
                                                        : false,
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
                                                        ? _usernameController
                                                            .text = value
                                                        : index == 1
                                                            ? _passwordController
                                                                .text = value
                                                            : index == 2
                                                                ? _cpasswordController
                                                                        .text =
                                                                    value
                                                                : index == 3
                                                                    ? _fnameController
                                                                            .text =
                                                                        value
                                                                    : index == 4
                                                                        ? _mnameController.text =
                                                                            value
                                                                        : index ==
                                                                                5
                                                                            ? _surnameController.text =
                                                                                value
                                                                            : null;
                                                  });
                                                },
                                                onTap: () {
                                                  index == 6
                                                      ? _selectDate(
                                                          context, 'DOB')
                                                      : index == 7
                                                          ? _showDropdown(
                                                              context, 'Gender')
                                                          : index == 8
                                                              ? _showDropdown(
                                                                  context,
                                                                  'Marital')
                                                              : null;
                                                },
                                              ),
                                            ),
                                            index == 1
                                                ? GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        obscureText =
                                                            !obscureText;
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: Icon(
                                                        obscureText
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  )
                                                : index == 2
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            obscureText1 =
                                                                !obscureText1;
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0.0),
                                                          child: Icon(
                                                            obscureText1
                                                                ? Icons
                                                                    .visibility
                                                                : Icons
                                                                    .visibility_off,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            height: 800,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFECEDF5),
                            ),
                            padding: EdgeInsets.only(
                                top: 25, bottom: 15, left: 20, right: 20),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      'Covid Vaccination',
                                      style: kvaccineTextStyle,
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
                                    borderRadius: BorderRadius.circular(10),
                                    color: kLoginTextFieldFillColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.vaccines,
                                          size: 20, color: kLoginIconColor),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _nameController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // contentPadding: EdgeInsets.symmetric(
                                            //     vertical: 8, horizontal: 0),
                                            isDense: true,
                                            hintText: 'Covid vaccine name',
                                            hintStyle: kLoginTextFieldTextStyle,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              _nameController.text = value;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: kLoginTextFieldFillColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_month_outlined,
                                          size: 20, color: kLoginIconColor),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: _firstDoseController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // contentPadding: EdgeInsets.symmetric(
                                            //     vertical: 8, horizontal: 0),
                                            isDense: true,
                                            hintText:
                                                'Covid vaccine dosage1 date',
                                            hintStyle: kLoginTextFieldTextStyle,
                                          ),
                                          onTap: () {
                                            _selectDate(context, "1");
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: kLoginTextFieldFillColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_month_outlined,
                                          size: 20, color: kLoginIconColor),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: _secondDoseController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // contentPadding: EdgeInsets.symmetric(
                                            //     vertical: 8, horizontal: 0),
                                            isDense: true,
                                            hintText:
                                                'Covid vaccine dosage2 date',
                                            hintStyle: kLoginTextFieldTextStyle,
                                          ),
                                          onTap: () {
                                            _selectDate(context, "2");
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 15),
                                  margin: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: kLoginTextFieldFillColor,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_month_outlined,
                                          size: 20, color: kLoginIconColor),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: _boostDoseController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            // contentPadding: EdgeInsets.symmetric(
                                            //     vertical: 8, horizontal: 0),
                                            isDense: true,
                                            hintText:
                                                'Covid vaccine booster date',
                                            hintStyle: kLoginTextFieldTextStyle,
                                          ),
                                          onTap: () {
                                            _selectDate(context, "3");
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
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
                              child: Text('Next', style: kButtonTextStyle),
                              onPressed: () {
                                if (isValidForm()) {
                                  submitPersonalDetails();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
