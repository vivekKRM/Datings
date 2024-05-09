import 'package:Dating/constants/styles.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';

class TermsCondition extends StatefulWidget {
  TermsCondition({Key? key, required this.title, required this.appManager})
      : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _TermsConditionState createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
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
              'Terms & Conditions',
              style: kHeaderTextStyle,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Container(
                      // margin: EdgeInsets.only(bottom: 40),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFECEDF5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Dating.net is a website to facilitate Shipping companies, Sea Farers and Marine Institutes to contact each other.\n\nIt provides information to Sea Farers regarding availability of Vacancies in various Shipping companies and, to Shipping companies the availability of Sea Farers.\n\nDating.net does not levy fees either for posting and searching resume.\n\nFresh and in-experience candidate will be charged for there advertisements in Dating.net.\n\nDating.net will charge companies for providing the availability and details of Sea Farers.\n\nNo individual or Organization has been authorized, on behalf if the web site, to collect any fee what so ever for accessing and posting resumes or searching for vacancies or resumes.\n\nDating.net wants the users of the website to be care full to maintain secrecy and security of the website.\n\nDating.net does not give guarantee that all resumes advertisements will be viewed by any particular or all users and within the specified time frame.\n\nDating.net does not entertain posting of any false or in-complete and in-accurate resumes and information's.\n\nAlso it does not give guarantee that everyone posts his/her resume will get the placement to his/her satisfaction.\n\nMembers may only logon using there own login id and password. They are not allowed to use Dating.net on behalf of others.\n\nDating.net shall initiate legal proceeding against any person or firm or organization indulging in activities such as :\n\na.)Breaking the terms and conditions as described as above.\n\nb.)Infringement of copy right, trade mark, trade secret or other intellectual property rights of others.",
                          style: kTermsTextStyle,
                        ),
                      ),
                    ),
                  ),
//Two floating button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kButtonColor,
                            ),
                            // margin: EdgeInsets.only(bottom: 30, top: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: kButtonColor,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, "/thank");
                              },
                              child: Text(
                                'Accept',
                                style: kButtonTextStyle,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            width:
                                16), // Adjust the spacing between buttons as needed
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kBoxInActiveColor,
                            ),
                            // margin: EdgeInsets.only(bottom: 30, top: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: kBoxInActiveColor,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, "/thank");
                              },
                              child: Text(
                                'Decline',
                                style: kPopupTitleTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
