import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getRank.dart';
import 'package:Dating/json/getRanks.dart';
import 'package:Dating/json/getShip.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchJob extends StatefulWidget {
  SearchJob({
    Key? key,
    required this.title,
    required this.appManager,
  }) : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _SearchJobState createState() => _SearchJobState();
}

class _SearchJobState extends State<SearchJob> {
  String token = '';
  String user_id = '';
  late FToast fToast;
  late SharedPreferences prefs;
  List<Ships> shipList = [];
  List<Rankers> rankList = [];
  String ship = '';
  String rank = '';
  List<String> texts = [
    'Select Ship',
    'Select Rank',
  ];
  TextEditingController _shipController = TextEditingController();
  TextEditingController _rankController = TextEditingController();

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

  Future<void> searchJob() async {
    final requestBody = {
      'user_id': user_id,
      'rank': rank,
      'ship': ship,
    };
    widget.appManager.apis
        .searchJob(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response?.status == 200) {
        showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        Navigator.pushNamed(context, "/joblisting", arguments: requestBody);
      } else if (response?.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to search job");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to search job: $error");
    });
  }

  void _showDropdown(BuildContext context, String type) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: ListView.builder(
            itemCount: type == 'Ship' ? shipList.length : rankList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  type == 'Ship'
                      ? shipList[index].seajob_name
                      : rankList[index].seajob_rank,
                  style: kDropDownTextStyle,
                ),
                onTap: () {
                  setState(() {
                    if (type == 'Ship') {
                      _shipController.text = shipList[index].seajob_name;
                      ship = shipList[index].seajob_id;
                    } else {
                      _rankController.text = rankList[index].seajob_rank;
                      rank = rankList[index].seajob_id;
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

  Future<void> getRank() async {
    prefs = await SharedPreferences.getInstance();
    final requestBody = {"": ''};
    widget.appManager.apis
        .getRank(requestBody, (prefs.getString('authToken') ?? ''))
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

  bool isValidForm() {
    if (_shipController.text == '') {
      showToast('Please select ship type', 2, kToastColor, context);
      return false;
    } else if (_rankController.text == '') {
      showToast('Please select rank', 2, kToastColor, context);
      return false;
    } else {
      FocusScope.of(context).unfocus();
      print("Proceed");
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    getPrefs();
    fToast.init(context);
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('sId') ?? '';
    getRank();
    getShip();
    // getCertificateDetails(user_id);
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
            'Search Job',
            style: kHeaderTextStyle,
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              color: kAppBarColor,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: texts.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            ? Icons.sailing
                                            : Icons.person_2_outlined,
                                        size: 20,
                                        color: kLoginIconColor,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: index == 0
                                              ? _shipController
                                              : _rankController,
                                          onTapAlwaysCalled: true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            isDense: true,
                                            hintText: '${texts[index]}',
                                            hintStyle: kLoginTextFieldTextStyle,
                                          ),
                                          onTap: () {
                                            index == 0
                                                ? _showDropdown(context, 'Ship')
                                                : _showDropdown(
                                                    context, 'Rank');
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
                      height: 200,
                    ),
                    Container(
                      width: size.width,
                      height: 65,
                      // margin: EdgeInsets.only(bottom: 30, top: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: kButtonColor,
                        ),
                        child: Text('Search', style: kButtonTextStyle),
                        onPressed: () {
                                if (isValidForm()) {
                                  searchJob();
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
