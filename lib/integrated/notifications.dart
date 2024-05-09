import 'package:Dating/constants/styles.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Notifications extends StatefulWidget {
  Notifications({
    Key? key,
    required this.title,
    required this.appManager,
  }) : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
  }

  List<String> notificatins = [
    "Lizzy sent you a message \"So where are you chatting from\"",
    "Lizzy sent you a message \"So where are you chatting from\"",
    "Lizzy sent you a message \"So where are you chatting from\"",
    "Lizzy sent you a message \"So where are you chatting from\"",
    "Lizzy sent you a message \"So where are you chatting from\"",
    "Lizzy sent you a message \"So where are you chatting from\"",
    "Lizzy sent you a message \"So where are you chatting from\"",
    "Lizzy sent you a message \"So where are you chatting from\"",
  ];
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
              'Activity',
              style: kHeaderTextStyle,
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: kAppBarColor,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: size.height * 0.85,
                      child: SizedBox(
                        height: size.height * 0.85,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: notificatins.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 22,
                                        backgroundImage:
                                            AssetImage('assets/user.png'),
                                      ),
                                      SizedBox(
                                          width:
                                              12), // Add some spacing between avatar and text
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${notificatins[index]}',
                                                      style:
                                                          kHeartRateTextTextStyle,
                                                    ),
                                                    TextSpan(
                                                        text: " 16th",
                                                        style:
                                                            kGoalCardTextStyle),
                                                  ]),
                                            ),
                                            SizedBox(
                                                height:
                                                    10), // Add some spacing between text and button
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: InkWell(
                                                onTap: () {},
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 5, 8, 5),
                                                  child: Text(
                                                    'GET VERIFIED',
                                                    style: kLoginTextFieldLabel
                                                        .copyWith(
                                                      letterSpacing:
                                                          1.5, // Adjust the value as needed
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 13,
                                  ),
                                  Container(
                                    height: 0.5,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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
