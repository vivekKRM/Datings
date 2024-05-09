import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getCountry.dart';
import 'package:Dating/json/getSeaman.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditSeamanDetails extends StatefulWidget {
  EditSeamanDetails(
      {Key? key,
      required this.title,
      required this.appManager,
      required this.updateBtn})
      : super(key: key);

  final String title;
  final AppManager appManager;
  final bool updateBtn;

  @override
  _EditSeamanDetailsState createState() => _EditSeamanDetailsState();
}

class _EditSeamanDetailsState extends State<EditSeamanDetails> {
  String user_id = '';
  late FToast fToast;
  late SharedPreferences prefs;
  List<Result?> seaman = [];

  Future<void> getSeamanDetails(String user_id) async {
    if (user_id != "") {
      final requestBody = {"user_id": user_id};
      widget.appManager.apis
          .getSeaman(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            seaman = [];
            seaman = response?.user ?? [];
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
    fToast = FToast();
    getPrefs();
    fToast.init(context);
    print(widget.updateBtn);
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('sId') ?? '';
    getSeamanDetails(user_id);
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
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: seaman.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFFECEDF5),
                                      ),
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 10,
                                          right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Seaman Book Details ${index + 1}',
                                            style: kvaccineTextStyle,
                                          ),
                                          Container(
                                            // width: size.width,
                                            // height: 45,
                                            // margin: EdgeInsets.only(
                                            //     bottom: 10, top: 10),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor: kButtonColor,
                                              ),
                                              child: Text('Edit',
                                                  style: kButtonTextStyle),
                                              onPressed: () {
                                                Map<String, dynamic> arguments =
                                                    {
                                                  'update': true,
                                                  'index':
                                                      seaman[index]?.bookid ??
                                                          '',
                                                  'add': false
                                                };
                                                Navigator.pushNamed(
                                                        context, "/seaman",
                                                        arguments: arguments)
                                                    .then((_) {
                                                  getSeamanDetails(user_id);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            );
                          },
                        ),
                        height: seaman.length * 100,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // color:
                          //     Colors.grey[200], // Set your desired background color
                        ),
                        child: InkWell(
                          onTap: () {
                            // setState(() {
                            //   seaman
                            //       .add(null); // Add a new entry to the seaman list
                            // });
                            Map<String, dynamic> arguments = {
                              'update': false,
                              'index': (seaman.length + 1).toString(),
                              'add': true
                            };
                            Navigator.pushNamed(context, "/seaman",
                                    arguments: arguments)
                                .then((_) {
                              getSeamanDetails(user_id);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      kButtonColor, // Set your desired circle color
                                ),
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.add,
                                  color: Colors
                                      .white, // Set your desired icon color
                                ),
                              ),
                              SizedBox(
                                  width:
                                      10), // Adjust spacing between icon and text
                              Text(
                                'Add More',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
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
