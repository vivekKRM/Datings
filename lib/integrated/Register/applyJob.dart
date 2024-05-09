import 'package:Dating/constants/developer-styles.dart';
import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getApplyJob.dart';
import 'package:Dating/json/getRank.dart';
import 'package:Dating/json/getRanks.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
class ApplyJob extends StatefulWidget {
  ApplyJob(
      {Key? key,
      required this.title,
      required this.appManager,
      required this.updateBtn})
      : super(key: key);

  final String title;
  final AppManager appManager;
  final bool updateBtn;

  @override
  _ApplyJobState createState() => _ApplyJobState();
}

class _ApplyJobState extends State<ApplyJob> {
  String token = '';
  late FToast fToast;
  String selectedItem = '';
  String user_id = '';
  List<Rankers> jobRank = [];
  List<Rankers> _selectedJobRanks = [];
  late SharedPreferences prefs;
  DateTime _selectedDate = DateTime.now();
  TextEditingController _jobController = TextEditingController();
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
    );
    if (pickedDate != null) {
      //&& pickedDate != _selectedDate
      setState(() {
        _selectedDate = pickedDate;
         String formattedDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
        type == "from"
            ? _fromDateController.text = formattedDate
            : _toDateController.text = formattedDate;
      });
    }
  }

  void _showDropdown(BuildContext context, String type) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FractionallySizedBox(
              heightFactor: 0.9,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: jobRank.length,
                        itemBuilder: (context, index) {
                          bool isSelected =
                              _selectedJobRanks.contains(jobRank[index]);
                          return ListTile(
                            title: Row(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  activeColor: kButtonColor,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value != null && value) {
                                        _selectedJobRanks.add(jobRank[index]);
                                      } else {
                                        _selectedJobRanks
                                            .remove(jobRank[index]);
                                      }
                                    });
                                  },
                                ),
                                Text(
                                  jobRank[index].seajob_rank,
                                  style: kDropDownTextStyle,
                                  maxLines: null,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedJobRanks.remove(jobRank[index]);
                                } else {
                                  _selectedJobRanks.add(jobRank[index]);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: 50,
                    margin: EdgeInsets.only(
                        bottom: 20, left: 25, right: 25, top: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: kButtonColor,
                      ),
                      child: Text('Done', style: kButtonTextStyle),
                      onPressed: () {
                        print(_selectedJobRanks
                            .map((job) => job.seajob_rank)
                            .toList());
                        String commaSeparatedValues = _selectedJobRanks
                            .map((job) => job.seajob_rank)
                            .toList()
                            .join(', ');
                        _jobController.text = commaSeparatedValues;
                        selectedItem = _selectedJobRanks
                            .map((job) => job.seajob_id)
                            .toList()
                            .join(',');

                        // Close the modal bottom sheet
                        Navigator.pop(context);
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

  Future<void> getRank() async {
    final requestBody = {"": ''};
    widget.appManager.apis
        .getRanks(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        jobRank = response.ranks;
        //  Navigator.pushReplacementNamed(context, '/login');
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to get rank");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get rank: $error");
    });
  }

  Future<void> submitJobDetails() async {
    String user_id = prefs.getString('sId') ?? '';
    final requestBody = {
      'page': '9',
      'user_id': user_id,
      'applypost': selectedItem,
      'from': _fromDateController.text,
      'to': _toDateController.text,
      'edit': '',
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
        print("Failed to submit job details");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to submit job details: $error");
    });
  }

  Future<void> updateJobDetails() async {
    String user_id = prefs.getString('sId') ?? '';
    final requestBody = {
      'page': '9',
      'user_id': user_id,
      'applypost': selectedItem,
      'from': _fromDateController.text,
      'to': _toDateController.text,
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
        print("Failed to submit job details");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to submit job details: $error");
    });
  }

  Future<void> getjobDetails(String user_id) async {
    if (user_id != "") {
      final requestBody = {"user_id": user_id};
      widget.appManager.apis
          .getjobDetails(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            selectedItem = response?.user?.rank.join(',') ?? '';
            _fromDateController.text = widget.appManager.utils
                .parseDate('dd-MMM-yyyy', response?.user?.from_date ?? '');
            _toDateController.text = widget.appManager.utils
                .parseDate('dd-MMM-yyyy', response?.user?.till_date ?? '');
            _jobController.text = response?.user?.rank_name.join(', ') ?? '';
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
          print("Failed to get applyjob data");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to get applyjob data: $error");
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
                          : Navigator.pushNamed(context, "/terms",
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
    if (_jobController.text == '') {
      showToast('Please select rank', 2, kToastColor, context);
      return false;
    } else if (_fromDateController.text == '') {
      showToast('Please select from date', 2, kToastColor, context);
      return false;
    } else if (_toDateController.text == '') {
      showToast('Please select to date', 2, kToastColor, context);
      return false;
    } else if (_fromDateController.text == _toDateController.text) {
      showToast('from and to date cannot be same', 2, kToastColor, context);
      return false;
    } else {
      print("Proceed");
      FocusScope.of(context).unfocus();
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
    fToast = FToast();
    getPrefs();
    fToast.init(context);
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('authToken') ?? '';
    user_id = prefs.getString('sId') ?? '';
    getRank();
    widget.updateBtn ? getjobDetails(user_id) : null;
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
            backgroundColor: kAppBarColor,
            surfaceTintColor: kAppBarColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Apply for Job',
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
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                              Icon(Icons.cabin,
                                  size: 20, color: kLoginIconColor),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _jobController,
                                  onTapAlwaysCalled: true,
                                  maxLines: null,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    hintText: 'Select Rank',
                                    hintStyle: kLoginTextFieldTextStyle,
                                  ),
                                  onTap: () {
                                    _showDropdown(context, 'job');
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        //Availability
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFECEDF5),
                          ),
                          padding:
                              EdgeInsets.only(top: 10, left: 20, right: 20),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 10, bottom: 9),
                                  child: Text(
                                    'Enter Availability',
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
                                    Icon(Icons.calendar_month_outlined,
                                        size: 20, color: kLoginIconColor),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: _fromDateController,
                                        onTapAlwaysCalled: true,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          hintText: 'From Date',
                                          hintStyle: kLoginTextFieldTextStyle,
                                        ),
                                        onTap: () {
                                          _selectDate(context, "from");
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
                                        controller: _toDateController,
                                        onTapAlwaysCalled: true,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          hintText: 'Till Date',
                                          hintStyle: kLoginTextFieldTextStyle,
                                        ),
                                        onTap: () {
                                          _selectDate(context, "to");
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
                          margin: EdgeInsets.only(bottom: 20, top: 20),
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
                                          ? updateJobDetails()
                                          : submitJobDetails();
                                    }
                                    //  Navigator.pushNamed(context, "/academic");
                                  },
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ));
  }
}
