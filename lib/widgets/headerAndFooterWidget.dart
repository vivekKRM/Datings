import 'package:Dating/constants/styles.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:Dating/widgets/customAppbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderAndFooter extends StatefulWidget {
  HeaderAndFooter({
    required this.leading,
    required this.titleText,
    required this.fabFunction,
    required this.homeFunction,
    required this.profileFunction,
    required this.bodyWidget,
    required this.appManager,
    required this.messageCount,
    this.keepFooter = true,
  });

  final Widget? leading;
  final String titleText;
  final Function homeFunction;
  final Function? profileFunction;
  final Function? fabFunction;
  final Widget bodyWidget;
  final AppManager appManager;
  final num messageCount;
  final bool keepFooter;

  @override
  _HeaderAndFooterState createState() => _HeaderAndFooterState();
}

class _HeaderAndFooterState extends State<HeaderAndFooter> {
  String fname = "";
  String lname = "";
  String email = "";
  String profilePic = "";
  String patientGroupPatientVisit = "true";
  String patientGroupPcpRequest = 'true';
  num messageC = 1;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    print("Selected Index: $index");
    setState(() {
      _selectedIndex = index;
    });
  }

  getPatientNameAndEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.setState(() {
      // this.fname = prefs.getString('fname') ?? '';
      // this.lname = prefs.getString('lname') ?? '';
      // this.email = prefs.getString('email') ?? '';
      // this.profilePic = prefs.getString('profilePic') ?? '';
      // this.patientGroupPatientVisit =
      //     prefs.getString('patientGroupPatientVisit') ?? 'true';
      // this.patientGroupPcpRequest =
      //     prefs.getString('patientGroupPcpRequest') ?? 'true';
      // // this.messageC = prefs.getInt('messageCount') ?? 0;
      // this.messageC = this.widget.messageCount != null
      //     ? this.widget.messageCount
      //     : prefs.getInt('messageCount') ?? 0;
    });
  }

  void bottomPopUpWidget() async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black38,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      builder: (BuildContext context) {
        return Container();
      },
    );
  }

  Future moveToMessage() async {
    //   SendAndForget resp =
    //       await this.widget.appManager.apis.makeConversationsAsSeenByPatient();
    //   if (resp.done ?? false) {
    //     print("Message Badge Updated");
    //     // Navigator.pushNamed(context, '/messages');

    //     Navigator.pushNamed(context, '/messages').then((result) {
    //       // Handle the result or callback here
    //       if (result != null) {
    //         print('Callback from Screen B: $result');
    //         Navigator.pushNamed(context, '/home');
    //       }
    //     });
    //     // Handle result if needed
    //   }
  }

  @override
  void didUpdateWidget(HeaderAndFooter oldWidget) {
    this.getPatientNameAndEmail();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getPatientNameAndEmail();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return (this.widget.keepFooter
        ? Scaffold(
            appBar: PreferredSize(
              
              preferredSize: Size.fromHeight(60),
              child: CustomAppbar(
                leading: this.widget.leading ?? Container(),
                titleText: this.widget.titleText,
                context: context,
              ),
            ),
            // endDrawer:
            // CustomDrawer(
            //   fname: this.fname,
            //   lname: this.lname,
            //   email: this.email,
            //   profilePic: this.profilePic,
            //   patientGroupPatientVisit: this.patientGroupPatientVisit,
            //   patientGroupPcpRequest: this.patientGroupPcpRequest,
            //   appManager: this.widget.appManager,
            // ),
            extendBody: true,
            extendBodyBehindAppBar: false,
            body: this.widget.bodyWidget,
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerDocked,
            // floatingActionButton: FloatingActionButton(
            //   shape: CircleBorder(),
            //   child: Icon(
            //     Icons.add,
            //     color: Colors.white,
            //   ),
            //   backgroundColor: kFABColor,
            //   // onPressed: this.widget.fabFunction,
            //   onPressed: this.bottomPopUpWidget,
            // ),
            bottomNavigationBar: BottomNavigationBar(
              selectedLabelStyle: kBackTextStyle,
              unselectedLabelStyle: kHeartRateTextTextStyle,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              showSelectedLabels: true,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  backgroundColor: Colors.lightGreen,
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.lightGreen,
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.lightGreen,
                  icon: Icon(Icons.favorite),
                  label: 'Like',
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.lightGreen,
                  icon: Stack(
                    children: [
                      Icon(Icons.message),
                      if (this.messageC > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Center(
                              // Center the text within the container
                              child: Text(
                                '${this.messageC}',
                                style: kButtonSmallTextStyle.copyWith(
                                    color: Colors
                                        .white), // Set text color to white
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.lightGreen,
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: CustomAppbar(
                leading: this.widget.leading ?? Container(),
                titleText: this.widget.titleText,
                context: context,
              ),
            ),
            // endDrawer:
            // CustomDrawer(
            //   fname: this.fname,
            //   lname: this.lname,
            //   email: this.email,
            //   profilePic: this.profilePic,
            //   patientGroupPatientVisit: this.patientGroupPatientVisit,
            //   patientGroupPcpRequest: this.patientGroupPcpRequest,
            //   appManager: this.widget.appManager,
            // ),
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: this.widget.bodyWidget,
          ));
  }
}
