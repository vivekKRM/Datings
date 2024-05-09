import 'package:Dating/constants/styles.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:Dating/widgets/headerAndFooterWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:swipe_cards/draggable_card.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen(
      {Key? key,
      required this.title,
      required this.appManager,
      required this.isRegister})
      : super(key: key);

  final String title;
  final AppManager appManager;
  final bool isRegister;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late String token = '';
  late SharedPreferences prefs;
  String user_id = '';
  late FToast fToast;
  String name = '';
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<String> _names = [
    "Dawin",
    "Puja",
    "Archana",
    "Merie",
    "deepa",
  ];
  List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
  ];

  List<Image> cardImages = [
    Image.asset(
      'assets/firstImage.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/secondImage.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/thirdImage.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/secondImage.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/firstImage.jpg',
      fit: BoxFit.cover,
    ),
  ];

  List<String> cardImage = [
    'assets/firstImage.jpg',
    'assets/secondImage.jpg',
    'assets/thirdImage.jpg',
    'assets/secondImage.jpg',
    'assets/firstImage.jpg',
  ];

  Future<void> getDashboard(String user_id) async {
    if (user_id != "") {
      final requestBody = {"user_id": user_id};
      widget.appManager.apis
          .getDashboardRequest(
              requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          prefs.setString('sId', response?.user?.id ?? '');
          prefs.setString('authToken', response?.token ?? '');
          setState(() {
            name = response?.user?.first_name ??
                '' +
                    ' ' +
                    (response?.user?.middle_name ?? '') +
                    ' ' +
                    (response?.user?.last_name ?? '');
          });
          await widget.appManager.markLoggedIn(response?.token ?? '');
          await widget.appManager.initSocket(response?.token ?? '');
          var loggedIn = await widget.appManager.hasLoggedIn();
        } else if (response?.status == 201) {
          showToast(response?.message ?? '', 2, kToastColor, context);
        } else if (response?.status == 502) {
          showLogoutDialog(BuildContext context) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LogoutAlert(
                  title: 'Active/Inactive Status',
                  subtitle: response?.message ?? '',
                  islogout: false,
                  logoutAction: () async {
                    await widget.appManager.clearLoggedIn();
                    if (widget.appManager.islogout == true) {
                      widget.appManager.utils.isPatientExitDialogShown = false;
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/obs', (route) => false);
                    }
                  },
                );
              },
            );
          }
        } else {
          print("Failed to get dashboard data");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to get dashboard data: $error");
      });
    } else {
      showToast('Please get user_id', 2, kToastColor, context);
    }
  }

  Future<void> logout() async {
    String user_id = prefs.getString('sId') ?? '';
    final requestBody = {
      '': '',
    };
    widget.appManager.apis
        .logout(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) async {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        print('Performing logout action...');
        await widget.appManager.clearLoggedIn();
        if (widget.appManager.islogout == true) {
          widget.appManager.utils.isPatientExitDialogShown = false;
          Navigator.pushNamedAndRemoveUntil(context, '/obs', (route) => false);
        }
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

  showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutAlert(
          title: 'Logout Confirmation',
          subtitle: 'Are you sure you want to logout?',
          islogout: true,
          logoutAction: () async {
            Navigator.pop(context);
            logout();
          },
        );
      },
    );
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
          // child: Stack(
          //   clipBehavior: Clip.none,
          //   children: [
          child: Container(
            height: 280,
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/congrats.gif',
                  width: 80,
                  height: 80,
                ),
                SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  widget.isRegister
                      ? "Welcome to Dating"
                      : 'Welcome back to Dating',
                  style: kCongratsTextStyle,
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
                    child: Text('Continue', style: kButtonTextStyle),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
          //     Positioned(
          //       right: -12,
          //       top: -10,
          //       child: GestureDetector(
          //         onTap: () {
          //           Navigator.of(context).pop();
          //         },
          //         child: Image.asset(
          //           'assets/cross.png',
          //           width: 40,
          //           height: 40,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
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
    fToast = FToast();
    getPrefs();
    fToast.init(context);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Navigator.pushNamed(context, "/welcome", arguments: widget.isRegister);
    // });
    for (int i = 0; i < _names.length; i++) {
      _swipeItems.add(SwipeItem(
          content: Content(text: _names[i], color: _colors[i]),
          likeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Liked ${_names[i]}"),
              duration: Duration(milliseconds: 500),
            ));
          },
          nopeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Nope ${_names[i]}"),
              duration: Duration(milliseconds: 500),
            ));
          },
          superlikeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Superliked ${_names[i]}"),
              duration: Duration(milliseconds: 500),
            ));
          },
          
          onSlideUpdate: (SlideRegion? region) async {
            print("Region $region");
          }));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('authToken') ?? '';
    user_id = prefs.getString('sId') ?? '';
    getDashboard(user_id);
  }

  final List<String> items = [
    'My Profile',
    'Job Search',
    'Bulk Resume Post',
    'Change Password',
    'Viewed By Company',
    'Hide/Unhide Company',
    'Shipping Companies(India)',
    'Logout',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // Disable back button
        return false;
      },
      child: HeaderAndFooter(
        messageCount: 0,
        leading: Image.asset(
          'assets/appicon.png',
          width: 35, // Adjust width as needed
          height: 35, // Adjust height as needed
        ),
        titleText: 'Dashboard',
        fabFunction: null,
        homeFunction: () {
          Navigator.pushNamed(context, 'home');
        },
        profileFunction: null,
        appManager: widget.appManager,
        bodyWidget: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5,100),
          child: Stack(children: [
            SwipeCards(
              matchEngine: _matchEngine!,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 8, // Fill 80% of available space
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              cardImage[index],
                              width: size.width * 0.96,
                              // height: size.height * 0.6,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      Flexible(
                        flex: 4, // Fill 20% of available space
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 8, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${_names[index]}',
                                    style:
                                        kCardValueTextStyle, //kButtonTextStyle,
                                  ),
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.home,
                                    size: 20,
                                    color: Color(0xFF454F63),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Lives in Delhi',
                                    style: kNotesCardNameTextStyle,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_pin,
                                    size: 20,
                                    color: Color(0xFF454F63),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    '20 km away',
                                    style: kNotesCardNameTextStyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              onStackFinished: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Stack Finished"),
                  duration: Duration(milliseconds: 500),
                ));
              },
              itemChanged: (SwipeItem item, int index) {
                print("item: ${item.content.text}, index: $index");
              },
              leftSwipeAllowed: true,
              rightSwipeAllowed: true,
              upSwipeAllowed: false,
              
              fillSpace: true,
              likeTag: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                child: Image.asset(
                  'assets/like.gif',
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                  width: 100,
                  height: 100,
                ),
              ),
              nopeTag: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.red)),
                child: Image.asset(
                  'assets/dislike.gif',
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                  width: 100,
                  height: 100,
                ),
              ),
              superLikeTag: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.orange)),
                child: Image.asset(
                  'assets/like.gif',
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _matchEngine!.currentItem?.nope();
                      },
                      child: Text("Nope")),
                  ElevatedButton(
                      onPressed: () async {
                        // _matchEngine!.currentItem?.superLike();
                    await widget.appManager.clearLoggedIn();
                    if (widget.appManager.islogout == true) {
                      widget.appManager.utils.isPatientExitDialogShown = false;
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/obs', (route) => false);
                    }
                      },
                      child: Text("Superlike")),
                  ElevatedButton(
                      onPressed: () {
                        _matchEngine!.currentItem?.like();
                      },
                      child: Text("Like"))
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

//Logout Class
class LogoutAlert extends StatelessWidget {
  final VoidCallback logoutAction; // Callback for logout action
  final String title;
  final String subtitle;
  final bool islogout;
  LogoutAlert(
      {required this.logoutAction,
      required this.title,
      required this.subtitle,
      required this.islogout});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: kHeaderTextStyle,
      ),
      content: Text(
        subtitle,
        style: kObsText,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            islogout ? 'Cancel' : 'Ok',
            style: klogoutcTextStyle,
          ),
        ),
        islogout
            ? TextButton(
                onPressed: logoutAction,
                child: Text(
                  'Logout',
                  style: klogoutTextStyle,
                ),
              )
            : Container(),
      ],
    );
  }
}

class Content {
  final String text;
  final Color color;

  Content({required this.text, required this.color});
}
