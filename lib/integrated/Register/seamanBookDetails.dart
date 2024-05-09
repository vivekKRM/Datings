import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getCountry.dart';
import 'package:Dating/json/getNationality.dart';
import 'package:Dating/json/getSeaman.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SeamanBookDetails extends StatefulWidget {
  SeamanBookDetails(
      {Key? key,
      required this.title,
      required this.appManager,
      required this.updateBtn})
      : super(key: key);

  final String title;
  final AppManager appManager;
  final Map<String, dynamic> updateBtn;

  @override
  _SeamanBookDetailsState createState() => _SeamanBookDetailsState();
}

class _SeamanBookDetailsState extends State<SeamanBookDetails> {
  late FToast fToast;
  List<String> texts = [
    'Issuing Authority',
    'Seaman Book Number',
    'Expiry Date',
  ];
  Map<String, dynamic> arguments = {
    'update': false,
    'index': '0',
    'add': false
  };
  bool update = false;
  String index = '';
  String token = '';
  bool add = false;
  String user_id = '';
  late SharedPreferences prefs;
  TextEditingController _issueController = TextEditingController();
  TextEditingController _bookController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<Country> authority = [];
  List<Result?> seaman = [];
  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        String formattedDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
        _expiryDateController.text = formattedDate;
      });
    }
  }

  Future<void> getCountry() async {
    prefs = await SharedPreferences.getInstance();
    final requestBody = {"": ''};
    widget.appManager.apis
        .getCountry(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        authority = response.country;
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

  void _showDropdown(BuildContext context, String type) {
    TextEditingController searchController = TextEditingController();
    List<dynamic> filteredAuthority = List.from(authority);

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
                        hintText: 'Search...',
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredAuthority = authority
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
                              _issueController.text =
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

  void _showCustomDialog(BuildContext context , int status) {
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
                  update == true
                      ? "Your information has been updated successfully."
                      : add == true && status == 0
                          ? "Your information has been added successfully."
                      : status == 1 ? 
                            "Seaman Book details already saved."
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
                          : Navigator.pushNamed(context, "/competency",
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

  Future<void> submitSeamanDetails() async {
    String user_id = prefs.getString('sId') ?? '';
    final requestBody = {
      'page': '4',
      'user_id': user_id,
      'authority': _issueController.text,
      'booknumber': _bookController.text,
      'seamanexpiry': _expiryDateController.text,
    };
    if (add == true) {
      requestBody['more'] = index;
    } else if (update == true) {
      requestBody['edit'] = 'e';
      requestBody['index'] = index;
    }
    widget.appManager.apis
        .sendRegister(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        // prefs.setString('sId', response?.user_id ?? '');
         if((response?.message ?? '').contains('already') && (add == true)){
            // _showCustomDialog(context, 1);
        }else{
          _showCustomDialog(context, 0);
        }
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to submit seaman data");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to submit seaman data: $error");
    });
  }

  Future<void> getSeamanDetails(String user_id) async {
    if (index != "") {
      final requestBody = {"seajob_id": index};
      widget.appManager.apis
          .getSingleSeaman(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            seaman = response?.user ?? [];
            _issueController.text = seaman[0]?.issueauth ?? '';
            _bookController.text = seaman[0]?.sbnumber ?? '';
            _expiryDateController.text = widget.appManager.utils
                .parseDate('dd-MMM-yyyy', seaman[0]?.expirydate ?? '');
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
          print("Failed to get seaman data");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to get seaman data: $error");
      });
    } else {
      showToast('Please get user_id', 2, kToastColor, context);
    }
  }

  bool isValidForm() {
    if (_issueController.text == '') {
      showToast('Please select issuing authority', 2, kToastColor, context);
      return false;
    } else if (_bookController.text == '') {
      showToast('Please enter seaman book number', 2, kToastColor, context);
      return false;
    } else if (_expiryDateController.text == '') {
      showToast(
          'please select seaman book expiry date', 2, kToastColor, context);
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
    getCountry();
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
    update ? getSeamanDetails(user_id) : null;
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
              'Seaman Book Details',
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
                          // scrollDirection: Axis.vertical,
                          itemCount: texts
                              .length, // Change this number as per your requirement
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
                                      color: kLoginTextFieldFillColor,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                            index == 0
                                                ? Icons.person_2_outlined
                                                : index == 1
                                                    ? Icons.book_online_outlined
                                                    : Icons
                                                        .calendar_month_outlined,
                                            size: 20,
                                            color: kLoginIconColor),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            readOnly: index == 0 || index == 2
                                                ? true
                                                : false,
                                            controller: index == 0
                                                ? _issueController
                                                : index == 1
                                                    ? _bookController
                                                    : _expiryDateController,
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
                                                    ? _bookController.text =
                                                        value
                                                    : null;
                                              });
                                            },
                                            inputFormatters: index == 1
                                                      ? [
                                                          // FilteringTextInputFormatter
                                                          //     .allow(RegExp(
                                                          //         r'[a-zA-Z0-9]')), // Allow letters and numbers
                                                          LengthLimitingTextInputFormatter(
                                                              12), // Limit the input to 12 characters
                                                        ]
                                                      : [
                                                          LengthLimitingTextInputFormatter(
                                                              200)
                                                        ],
                                            onTap: () {
                                              index == 0
                                                  ? _showDropdown(
                                                      context, 'Country')
                                                  : index == 2
                                                      ? _selectDate(context,
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
                        height: 300,
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
                              update == true
                                  ? 'Update'
                                  : add == true
                                      ? 'Add'
                                      : 'Next',
                              style: kButtonTextStyle),
                          onPressed: () {
                                  if (isValidForm()) {
                                    submitSeamanDetails();
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
