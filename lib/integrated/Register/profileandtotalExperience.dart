import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getCertificate.dart';
import 'package:Dating/json/getCountry.dart';
import 'package:Dating/json/getNationality.dart';
import 'package:Dating/json/getProfileExperience.dart';
import 'package:Dating/json/getRank.dart';
import 'package:Dating/json/getRanks.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileandtotalExperience extends StatefulWidget {
  ProfileandtotalExperience(
      {Key? key,
      required this.title,
      required this.appManager,
      required this.updateBtn})
      : super(key: key);

  final String title;
  final AppManager appManager;
  final bool updateBtn;

  @override
  _ProfileandtotalExperienceState createState() =>
      _ProfileandtotalExperienceState();
}

class _ProfileandtotalExperienceState extends State<ProfileandtotalExperience> {
  late FToast fToast;
  List<String> texts = [
    'Rank',
    'Year',
    'Month',
    'Day',
  ];
  List<Result?> profileExperience = [];
  String firstRank = "";
  String secondRank = "";
  String thirdRank = "";
  List<Rankers> rankList = [];
  String token = '';
  String user_id = '';
  late SharedPreferences prefs;
  TextEditingController _firstRankController = TextEditingController();
  TextEditingController _firstYearController = TextEditingController();
  TextEditingController _firstMonthController = TextEditingController();
  TextEditingController _firstDayController = TextEditingController();
  TextEditingController _secondRankController = TextEditingController();
  TextEditingController _secondYearController = TextEditingController();
  TextEditingController _secondMonthController = TextEditingController();
  TextEditingController _secondDayController = TextEditingController();
  TextEditingController _thirdRankController = TextEditingController();
  TextEditingController _thirdYearController = TextEditingController();
  TextEditingController _thirdMonthController = TextEditingController();
  TextEditingController _thirdDayController = TextEditingController();
  TextEditingController _jobprofileController = TextEditingController();

  List<Ranks> rankslists = [];
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
                          : Navigator.pushNamed(context, "/job",
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

  Future<void> getRank() async {
    prefs = await SharedPreferences.getInstance();
    final requestBody = {"": ''};
    widget.appManager.apis
        .getRanks(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        rankList = response.ranks;
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

  void _showDropdown(BuildContext context, String type) {
    List<Rankers> filteredList =
        List.from(rankList); // Copy of original list for filtering
    TextEditingController searchController = TextEditingController();

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
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredList = rankList
                              .where((rank) => rank.seajob_rank
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            filteredList[index].seajob_rank,
                            style: kDropDownTextStyle,
                          ),
                          onTap: () {
                            setState(() {
                              if (type == "firstRank") {
                                _firstRankController.text =
                                    filteredList[index].seajob_rank;
                                firstRank = filteredList[index].seajob_id;
                              } else if (type == "secondRank") {
                                _secondRankController.text =
                                    filteredList[index].seajob_rank;
                                secondRank = filteredList[index].seajob_id;
                              } else {
                                _thirdRankController.text =
                                    filteredList[index].seajob_rank;
                                thirdRank = filteredList[index].seajob_id;
                              }
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

  Future<void> submitExperienceDetails() async {
    String user_id = prefs.getString('sId') ?? '';
    final requestBody = {
      'page': '8',
      'user_id': user_id,
      'rank1': _firstRankController.text != '' ? firstRank : '',
      'rank2': _secondRankController.text != '' ? secondRank : '',
      'rank3': _thirdRankController.text != '' ? thirdRank : '',
      'month1': _firstMonthController.text,
      'year1': _firstYearController.text,
      'day1': _firstDayController.text,
      'month2': _secondMonthController.text,
      'year2': _secondYearController.text,
      'day2': _secondDayController.text,
      'month3': _thirdMonthController.text,
      'year3': _thirdYearController.text,
      'day3': _thirdDayController.text,
      'profile': _jobprofileController.text,
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
        print("Failed to submit profileExperience");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to submit profileExperience: $error");
    });
  }

  Future<void> updateExperienceDetails() async {
    String user_id = prefs.getString('sId') ?? '';
    final requestBody = {
      'page': '8',
      'user_id': user_id,
      'rank1': _firstRankController.text != '' ? firstRank : '',
      'rank2': _secondRankController.text != '' ? secondRank : '',
      'rank3': _thirdRankController.text != '' ? thirdRank : '',
      'month1': _firstMonthController.text,
      'year1': _firstYearController.text,
      'day1': _firstDayController.text,
      'month2': _secondMonthController.text,
      'year2': _secondYearController.text,
      'day2': _secondDayController.text,
      'month3': _thirdMonthController.text,
      'year3': _thirdYearController.text,
      'day3': _thirdDayController.text,
      'profile': _jobprofileController.text,
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
        print("Failed to update profileExperience");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to update profileExperience: $error");
    });
  }

  Future<void> getProfileExperienceDetails(String user_id) async {
    if (user_id != "") {
      final requestBody = {"user_id": user_id};
      widget.appManager.apis
          .getProfileExperienceDetails(
              requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            profileExperience = response?.user ?? [];
            firstRank = profileExperience[0]?.rank ?? '';
            secondRank = profileExperience[1]?.rank ?? '';
            thirdRank = profileExperience[2]?.rank ?? '';
            _firstRankController.text = profileExperience[0]?.rankname ?? '';
            _secondRankController.text = profileExperience[1]?.rankname ?? '';
            _thirdRankController.text = profileExperience[2]?.rankname ?? '';
            _firstMonthController.text = profileExperience[0]?.month ?? '';
            _secondMonthController.text = profileExperience[1]?.month ?? '';
            _thirdMonthController.text = profileExperience[2]?.month ?? '';
            _firstYearController.text = profileExperience[0]?.year ?? '';
            _secondYearController.text = profileExperience[1]?.year ?? '';
            _thirdYearController.text = profileExperience[2]?.year ?? '';
            _firstDayController.text = profileExperience[0]?.day ?? '';
            _secondDayController.text = profileExperience[1]?.day ?? '';
            _thirdDayController.text = profileExperience[2]?.day ?? '';
            _jobprofileController.text = profileExperience[0]?.jobprofile ?? '';
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
    if (_firstRankController.text == '') {
      showToast('Please select rank', 2, kToastColor, context);
      return false;
    } else if (_firstYearController.text == '') {
      showToast('Please enter ${_firstRankController.text} year experience', 2,
          kToastColor, context);
      return false;
    } else if (_firstMonthController.text == '') {
      showToast('Please enter ${_firstRankController.text} month experience', 2,
          kToastColor, context);
      return false;
    } else if (_firstDayController.text == '') {
      showToast('Please enter ${_firstRankController.text} day experience', 2,
          kToastColor, context);
      return false;
    } else if (_secondRankController.text != '') {
      if (_secondYearController.text == '') {
        showToast('Please enter ${_secondRankController.text} year experience',
            2, kToastColor, context);
        return false;
      } else if (_secondMonthController.text == '') {
        showToast('Please enter ${_secondRankController.text} month experience',
            2, kToastColor, context);
        return false;
      } else if (_secondDayController.text == '') {
        showToast('Please enter ${_secondRankController.text} day experience',
            2, kToastColor, context);
        return false;
      }
      return true;
    } else if (_thirdRankController.text != '') {
      if (_thirdYearController.text == '') {
        showToast('Please enter ${_thirdRankController.text} year experience',
            2, kToastColor, context);
        return false;
      } else if (_thirdMonthController.text == '') {
        showToast('Please enter ${_thirdRankController.text} month experience',
            2, kToastColor, context);
        return false;
      } else if (_thirdDayController.text == '') {
        showToast('Please enter ${_thirdRankController.text} day experience', 2,
            kToastColor, context);
        return false;
      }
      return true;
    // } else if (_jobprofileController.text == '') {
    //   showToast('Please enter job profile', 2, kToastColor, context);
    //   return false;
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
    getRank();
    widget.updateBtn ? getProfileExperienceDetails(user_id) : null;
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
              'Profile And Total Experience',
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
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, bottom: 9),
                                child: Text(
                                  'Experience',
                                  style: kvaccineTextStyle,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kLoginTextFieldFillColor,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_pin,
                                      size: 20,
                                      color: kLoginIconColor,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        readOnly: true,
                                        controller: _firstRankController,
                                        onTapAlwaysCalled: true,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          hintText: 'Rank',
                                          hintStyle: kLoginTextFieldTextStyle,
                                        ),
                                        onTap: () {
                                          _showDropdown(context, 'firstRank');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: kLoginTextFieldFillColor,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.date_range_outlined,
                                            size: 15,
                                            color: kLoginIconColor,
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              readOnly: false,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    2)
                                              ],
                                              controller: _firstYearController,
                                              onTapAlwaysCalled: true,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                hintText: 'Year',
                                                hintStyle:
                                                    kLoginTextFieldTextStyle,
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  _firstYearController.text =
                                                      value;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: kLoginTextFieldFillColor,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.date_range_outlined,
                                            size: 15,
                                            color: kLoginIconColor,
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              readOnly: false,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    2)
                                              ],
                                              controller: _firstMonthController,
                                              onTapAlwaysCalled: true,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                hintText: 'Month',
                                                hintStyle:
                                                    kLoginTextFieldTextStyle,
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  _firstMonthController.text =
                                                      value;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: kLoginTextFieldFillColor,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.date_range_outlined,
                                            size: 15,
                                            color: kLoginIconColor,
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              readOnly: false,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    2)
                                              ],
                                              controller: _firstDayController,
                                              textAlign: TextAlign.center,
                                              onTapAlwaysCalled: true,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                hintText: 'Day',
                                                hintStyle:
                                                    kLoginTextFieldTextStyle,
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  _firstDayController.text =
                                                      value;
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
                            ),
                          ],
                        ),
                        height: 240,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      //Another Experience
                      _firstDayController.text != ''
                          ? Container(
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
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 10, bottom: 9),
                                      child: Text(
                                        'Experience',
                                        style: kvaccineTextStyle,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: kLoginTextFieldFillColor,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person_pin,
                                            size: 20,
                                            color: kLoginIconColor,
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              readOnly: true,
                                              controller: _secondRankController,
                                              onTapAlwaysCalled: true,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                hintText: 'Rank',
                                                hintStyle:
                                                    kLoginTextFieldTextStyle,
                                              ),
                                              onTap: () {
                                                _showDropdown(
                                                    context, 'secondRank');
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
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
                                                  Icons.date_range_outlined,
                                                  size: 15,
                                                  color: kLoginIconColor,
                                                ),
                                                SizedBox(width: 5),
                                                Expanded(
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    readOnly: false,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          2)
                                                    ],
                                                    controller:
                                                        _secondYearController,
                                                    onTapAlwaysCalled: true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      isDense: true,
                                                      hintText: 'Year',
                                                      hintStyle:
                                                          kLoginTextFieldTextStyle,
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _secondYearController
                                                            .text = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
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
                                                  Icons.date_range_outlined,
                                                  size: 15,
                                                  color: kLoginIconColor,
                                                ),
                                                SizedBox(width: 5),
                                                Expanded(
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    readOnly: false,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          2)
                                                    ],
                                                    textAlign: TextAlign.center,
                                                    controller:
                                                        _secondMonthController,
                                                    onTapAlwaysCalled: true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      isDense: true,
                                                      hintText: 'Month',
                                                      hintStyle:
                                                          kLoginTextFieldTextStyle,
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _secondMonthController
                                                            .text = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
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
                                                  Icons.date_range_outlined,
                                                  size: 15,
                                                  color: kLoginIconColor,
                                                ),
                                                SizedBox(width: 5),
                                                Expanded(
                                                  child: TextFormField(
                                                    textAlign: TextAlign.center,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    readOnly: false,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          2)
                                                    ],
                                                    controller:
                                                        _secondDayController,
                                                    onTapAlwaysCalled: true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      isDense: true,
                                                      hintText: 'Day',
                                                      hintStyle:
                                                          kLoginTextFieldTextStyle,
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _secondDayController
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
                                  ),
                                ],
                              ),
                              height: 240,
                            )
                          : Container(),
                      SizedBox(
                        height: 25,
                      ),
                      _secondDayController.text != ''
                          ?
                          //Another Experience
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
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 10, bottom: 9),
                                      child: Text(
                                        'Experience',
                                        style: kvaccineTextStyle,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: kLoginTextFieldFillColor,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person_pin,
                                            size: 20,
                                            color: kLoginIconColor,
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              readOnly: true,
                                              controller: _thirdRankController,
                                              onTapAlwaysCalled: true,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                hintText: 'Rank',
                                                hintStyle:
                                                    kLoginTextFieldTextStyle,
                                              ),
                                              onTap: () {
                                                _showDropdown(
                                                    context, 'thirdRank');
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
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
                                                  Icons.date_range_outlined,
                                                  size: 15,
                                                  color: kLoginIconColor,
                                                ),
                                                SizedBox(width: 5),
                                                Expanded(
                                                  child: TextFormField(
                                                    textAlign: TextAlign.center,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    readOnly: false,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          2)
                                                    ],
                                                    controller:
                                                        _thirdYearController,
                                                    onTapAlwaysCalled: true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      isDense: true,
                                                      hintText: 'Year',
                                                      hintStyle:
                                                          kLoginTextFieldTextStyle,
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _thirdYearController
                                                            .text = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
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
                                                  Icons.date_range_outlined,
                                                  size: 15,
                                                  color: kLoginIconColor,
                                                ),
                                                SizedBox(width: 5),
                                                Expanded(
                                                  child: TextFormField(
                                                    textAlign: TextAlign.center,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    readOnly: false,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          2)
                                                    ],
                                                    controller:
                                                        _thirdMonthController,
                                                    onTapAlwaysCalled: true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      isDense: true,
                                                      hintText: 'Month',
                                                      hintStyle:
                                                          kLoginTextFieldTextStyle,
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _thirdMonthController
                                                            .text = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Container(
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
                                                  Icons.date_range_outlined,
                                                  size: 15,
                                                  color: kLoginIconColor,
                                                ),
                                                SizedBox(width: 5),
                                                Expanded(
                                                  child: TextFormField(
                                                    textAlign: TextAlign.center,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    readOnly: false,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          2)
                                                    ],
                                                    controller:
                                                        _thirdDayController,
                                                    onTapAlwaysCalled: true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      isDense: true,
                                                      hintText: 'Day',
                                                      hintStyle:
                                                          kLoginTextFieldTextStyle,
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _thirdDayController
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
                                  ),
                                ],
                              ),
                              height: 240,
                            )
                          : Container(),
//Job Profile
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFECEDF5),
                        ),
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 20),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, bottom: 9, top: 10),
                                child: Text(
                                  'Job Profile',
                                  style: kvaccineTextStyle,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kLoginTextFieldFillColor,
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.home_repair_service_rounded,
                                      size: 20, color: kLoginIconColor),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _jobprofileController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        hintText: 'Enter Job Profile',
                                        hintStyle: kLoginTextFieldTextStyle,
                                      ),
                                      maxLines: null,
                                      onChanged: (value) {
                                        setState(() {
                                          _jobprofileController.text = value;
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
                      //Next Button
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
                                        ? updateExperienceDetails()
                                        : submitExperienceDetails();
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
