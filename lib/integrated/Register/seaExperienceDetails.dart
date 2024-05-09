import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getEngine.dart';
import 'package:Dating/json/getRank.dart';
import 'package:Dating/json/getRanks.dart';
import 'package:Dating/json/getSeaExperience.dart';
import 'package:Dating/json/getShip.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SeaExperienceDetails extends StatefulWidget {
  SeaExperienceDetails(
      {Key? key,
      required this.title,
      required this.appManager,
      required this.updateBtn})
      : super(key: key);

  final String title;
  final AppManager appManager;
  final Map<String, dynamic> updateBtn;
  @override
  _SeaExperienceDetailsState createState() => _SeaExperienceDetailsState();
}

class _SeaExperienceDetailsState extends State<SeaExperienceDetails> {
  String token = '';
  List<Rankers> rankList = [];
  List<Ships> shipList = [];
  List<Engines> engineList = [];
  List<Result?> seaExperience = [];
  late FToast fToast;
  late SharedPreferences prefs;
  bool update = false;
  String index = '';
  bool add = false;
  String user_id = '';
  List<String> texts = [
    'Rank',
    'Company',
    'Type Of Ship',
    'Tonnage',
    'Main Engine',
    'Engine(BHP)',
    'Sign On Date',
    'Sign Off Date',
  ];
  String rankId = '';
  String shipId = '';
  String engineId = '';
  DateTime _selectedDate = DateTime.now();
  TextEditingController _rankController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _shiptypeController = TextEditingController();
  TextEditingController _tonnageController = TextEditingController();
  TextEditingController _engineController = TextEditingController();
  TextEditingController _engainController = TextEditingController();
  TextEditingController _signonController = TextEditingController();
  TextEditingController _signoffController = TextEditingController();

  Future<void> _selectDate(BuildContext context, String type) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      //&& pickedDate != _selectedDate
      setState(() {
        _selectedDate = pickedDate;
         String formattedDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
        type == "On"
            ? _signonController.text = formattedDate
            : _signoffController.text = formattedDate;
      });
    }
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

  Future<void> getShip() async {
    prefs = await SharedPreferences.getInstance();
    final requestBody = {"": ''};
    widget.appManager.apis
        .getShip(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        shipList = response.ships;

        //  Navigator.pushReplacementNamed(context, '/login');
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to get ship");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get ship: $error");
    });
  }

  Future<void> getEngine() async {
    prefs = await SharedPreferences.getInstance();
    final requestBody = {"": ''};
    widget.appManager.apis
        .getEngine(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        engineList = response.engines;
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to get engine");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get engine: $error");
    });
  }

  void _showDropdown(BuildContext context, String type) {
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                        setState(() {});
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: type == "Rank"
                          ? rankList.length
                          : type == "Engine"
                              ? engineList.length
                              : shipList.length,
                      itemBuilder: (context, index) {
                        final item = type == "Rank"
                            ? rankList[index].seajob_rank
                            : type == "Engine"
                                ? engineList[index].seajob_engine
                                : shipList[index].seajob_name;
                        return item
                                .toLowerCase()
                                .contains(searchController.text.toLowerCase())
                            ? ListTile(
                                title: Text(
                                  item,
                                  style: kDropDownTextStyle,
                                ),
                                onTap: () {
                                  setState(() {
                                    if (type == "Rank") {
                                      rankId = rankList[index].seajob_id;
                                      _rankController.text =
                                          rankList[index].seajob_rank;
                                    } else if (type == "Engine") {
                                      engineId = engineList[index].seajob_id;
                                      _engineController.text =
                                          engineList[index].seajob_engine;
                                    } else {
                                      shipId = shipList[index].seajob_id;
                                      _shiptypeController.text =
                                          shipList[index].seajob_name;
                                    }
                                  });
                                  Navigator.of(context).pop();
                                },
                              )
                            : SizedBox.shrink();
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
      'page': '7',
      'user_id': user_id,
      'seajob_rank': rankId,
      'company': _companyController.text,
      'seajob_ship': shipId,
      'seajob_engine': engineId,
      'enginebhp': _engainController.text,
      'tonnage': _tonnageController.text,
      'issue': _signonController.text,
      'expiry': _signoffController.text,
      'edit': update == true ? 'e' : '',
    
    };
    if (add == true) {
      requestBody['more'] = index;
    }else if(update == true){
      requestBody['seajob_id'] = index;
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
        print("Failed to submit sea experience details");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to submit sea experience details: $error");
    });
  }

  Future<void> getExperienceDetails(String user_id) async {
    if (index != "") {
      final requestBody = {"seajob_id": index};
      widget.appManager.apis
          .getSingleSeaExperienceDetails(
              requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            seaExperience = response?.user ?? [];
            rankId = response?.user[0]?.Datingrank ?? '';
            _companyController.text = response?.user[0]?.companyname ?? '';
            shipId = response?.user[0]?.shiptype ?? '';
            engineId = response?.user[0]?.mainengine ?? '';
            _engainController.text = response?.user[0]?.bhp ?? '';
            _tonnageController.text = response?.user[0]?.tonnage ?? '';
            _signonController.text = widget.appManager.utils
                .parseDate('dd-MMM-yyyy', response?.user[0]?.joindate ?? '');
            _signoffController.text = widget.appManager.utils
                .parseDate('dd-MMM-yyyy', response?.user[0]?.leavedate ?? '');
            _engineController.text = response?.user[0]?.certname ?? '';
            _shiptypeController.text = response?.user[0]?.shipname ?? '';
            _rankController.text = response?.user[0]?.rankname ?? '';
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

  void _showCustomDialog(BuildContext context, int status) {
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
                            "Sea Experience details already saved."
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
                          : Navigator.pushNamed(context, "/profilexperience",
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
    if (_rankController.text == '') {
      showToast('Please choose rank', 2, kToastColor, context);
      return false;
    } else if (_companyController.text == '') {
      showToast('Please enter company', 2, kToastColor, context);
      return false;
    } else if (_shiptypeController.text == '') {
      showToast('Please choose ship type', 2, kToastColor, context);
      return false;
    } else if (_tonnageController.text == '') {
      showToast('Please enter tonnage', 2, kToastColor, context);
      return false;
    } else if (_engineController.text == '') {
      showToast('Please select main engine', 2, kToastColor, context);
      return false;
    } else if (_engainController.text == '') {
      showToast('Please enter engine in BHP', 2, kToastColor, context);
      return false;
    } else if (_signonController.text == '') {
      showToast('Please select sign on date', 2, kToastColor, context);
      return false;
    } else if (_signoffController.text == '') {
      showToast('Please select sign off date', 2, kToastColor, context);
      return false;
    } else if (_signonController.text == _signoffController.text) {
      showToast('Signon date and Signoff date cannot be same', 2, kToastColor,
          context);
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
    getRank();
    getShip();
    getEngine();
    user_id = prefs.getString('sId') ?? '';
    update = widget.updateBtn['update'] as bool;
    index = widget.updateBtn['index'] as String;
    add = widget.updateBtn['add'] as bool;
    update ? getExperienceDetails(user_id) : null;
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
              'Sea Experience Details',
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
                  padding: EdgeInsets.all(10.0),
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 15),
                                    //  margin: EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: kLoginTextFieldFillColor,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                            index == 5
                                                ? Icons.two_wheeler
                                                : index == 4
                                                    ? Icons.engineering
                                                    : index == 3
                                                        ? Icons.token_outlined
                                                        : index == 2
                                                            ? Icons.houseboat
                                                            : index == 1
                                                                ? Icons.house
                                                                : index == 6 ||
                                                                        index ==
                                                                            7
                                                                    ? Icons
                                                                        .calendar_month_outlined
                                                                    : Icons
                                                                        .person_pin,
                                            size: 20,
                                            color: kLoginIconColor),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: TextFormField(
                                            readOnly: index == 0 ||
                                                    index == 2 ||
                                                    index == 4 ||
                                                    index == 6 ||
                                                    index == 7
                                                ? true
                                                : false,
                                            controller: index == 6
                                                ? _signonController
                                                : index == 7
                                                    ? _signoffController
                                                    : index == 0
                                                        ? _rankController
                                                        : index == 1
                                                            ? _companyController
                                                            : index == 2
                                                                ? _shiptypeController
                                                                : index == 3
                                                                    ? _tonnageController
                                                                    : index == 4
                                                                        ? _engineController
                                                                        : index ==
                                                                                5
                                                                            ? _engainController
                                                                            : null,
                                            onTapAlwaysCalled: true,
                                            keyboardType: index == 5
                                                ? TextInputType.number
                                                : TextInputType.text,
                                            inputFormatters:
                                                index == 1 || index == 3
                                                    ? [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r'[a-zA-Z0-9]')), // Allow letters and numbers
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
                                                    ? _companyController.text =
                                                        value
                                                    : index == 3
                                                        ? _tonnageController
                                                            .text = value
                                                        : index == 5
                                                            ? _engainController
                                                                .text = value
                                                            : null;
                                              });
                                            },
                                            onTap: () {
                                              index == 6
                                                  ? _selectDate(context, 'On')
                                                  : index == 7
                                                      ? _selectDate(
                                                          context, 'Off')
                                                      : index == 0
                                                          ? _showDropdown(
                                                              context, 'Rank')
                                                          : index == 2
                                                              ? _showDropdown(
                                                                  context,
                                                                  'Ship')
                                                              : index == 4
                                                                  ? _showDropdown(
                                                                      context,
                                                                      'Engine')
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
                        height: 740,
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
                                    submitExperienceDetails();
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
