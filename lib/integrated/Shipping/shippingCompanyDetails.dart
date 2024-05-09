import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getRank.dart';
import 'package:Dating/json/getShip.dart';
import 'package:Dating/json/getSingleShipping.dart';
import 'package:Dating/json/jobSearch.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingCompanyDetails extends StatefulWidget {
  ShippingCompanyDetails({
    Key? key,
    required this.title,
    required this.appManager,
    required this.comp_id,
  }) : super(key: key);

  final String title;
  final AppManager appManager;
  final String comp_id;

  @override
  _ShippingCompanyDetailsState createState() => _ShippingCompanyDetailsState();
}

class _ShippingCompanyDetailsState extends State<ShippingCompanyDetails> {
  String token = '';
  String user_id = '';
  late FToast fToast;
  late SharedPreferences prefs;
  String postid = '';
  String compid = '';
  late Result? getcompany = null;
  List<String> texts = [
    'Select Ship',
    'Select Rank',
  ];

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

  Future<void> getcompanydetail(String user_id) async {
    if (widget.comp_id != "") {
      final requestBody = {
        'compid': widget.comp_id,
      };
      widget.appManager.apis
          .companydetail(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // prefs.setString('sId', response?.user?.id ?? '');
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            getcompany = (response?.user) as Result?;
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
          print("Failed to get company detail data");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to get company detail data: $error");
      });
    } else {
      showToast('Please get user_id', 2, kToastColor, context);
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
    getcompanydetail(user_id);
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
              'Company Details',
              style: kHeaderTextStyle,
            ),
          ),
          body: Container(
            color: kAppBarColor,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            textAlign: TextAlign.left,
                            'Name: ' + (getcompany?.companyname ?? ''),
                            style: kalertTitleTextStyle,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Address: ' + (getcompany?.address ?? ''),
                            style: kalertTitleTextStyle,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Email: ' + (getcompany?.email ?? ''),
                            style: kalertTitleTextStyle,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Web: ' + (getcompany?.url ?? ''),
                            style: kalertTitleTextStyle,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Phone: ' + (getcompany?.phone ?? ''),
                            style: kalertTitleTextStyle,
                          ),
                        ],
                      ),
                    ),
                    height: 700,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
