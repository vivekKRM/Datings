import 'package:Dating/constants/styles.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Consent extends StatefulWidget {
  Consent({
    Key? key,
    required this.title,
    required this.appManager,
  }) : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _ConsentState createState() => _ConsentState();
}

class _ConsentState extends State<Consent> {
//  late AcceptPatientConsent patientConsent;

  List<String> head = [
    'G89.4',
    'M79.606',
    'M05.9',
    'M67.90',
    'M51.9',
    'M51.36',
    'M54.5',
    'M19.90',
    'M50.90',
    'M54.6',
    'M25.569',
    'M54.5',
    'M62.830',
    'M47.816',
    'G56.0',
    'M54.2',
    'M25.559',
    'M47.816',
  ];
  List<String> subhead = [
    'Chronic pain syndrome',
    'Leg Pain',
    'Rheumatoid Arthritis',
    'Tendonitis',
    'Herniated Disc',
    'Degenerative Disc Disease',
    'Chronic Low Back Pain',
    'Osteoarthritis',
    'Cervical Disc Disorder',
    'Thoracic Pain',
    'Knee Pain',
    'Lumbar Region Pain',
    'Spasm of Back Muscle',
    'Lumbar Spondylosis',
    'Carpal Tunnel Syndrome',
    'Neck pain',
    'Hip Pain',
    'Lumbar Facet Joint Pain',
  ];

  List<String> bullets = [
    'Your physician or other healthcare provider has explained to you what RTM means, the type of health data that will be collected, and how it will be used in your care;',
    'You are aware that your health data will be collected and transmitted digitally from an RTM technology, such as a mobile patient app to your healthcare provider in a safe and secure manner to maintain the confidentiality of your healthcare information;',
    'You will not transmit or allow to be transmitted the health data of any individual other than your own;',
    'You will not intentionally tamper with any RTM device used in connection with your RTM services;',
    'Your physician or healthcare provider is not responsible for inaccuracies in the health data transmitted;',
    'You consent to the use of RTM services as part of your care and treatment;',
    'You have the right to withdraw this consent at any time;',
    'You consent to receive text messages regarding this program and understand standard text messaging rates may apply. Additionally, you may opt-out at any time.',
    'You are responsible for all applicable copay and deductible amounts (including, if you are a Medicare beneficiary, the 20% copay for Part B services); RTM services are NOT emergency services and your data WILL NOT BE MONITORED 24/7. If you think you are experiencing a medical emergency, CALL 911 IMMEDIATELY.',
  ];

  late List<Item> items;

  acceptPatientConsent() async {
    // AcceptPatientConsent resp =
    //     await this.widget.appManager.apis.acceptPatientConsent();
    // if (resp.done) {
    //   this.setState(() {
    //     patientConsent = resp;
    //     Navigator.pushReplacementNamed(context, '/home');
    //   });
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = List.generate(
      head.length,
      (index) => Item(head[index], subhead[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.fromLTRB(20, 40, 20, 50),
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(15),
              child: Text(
                "Patient Consent",
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
              alignment: Alignment.centerLeft,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                height: 200,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            "Patient's Name: ",
                            style: kConsentNameTextStyle,
                          ),
                          Text(
                            'Vivek Kumar',
                            style:
                                kConsentNameTextStyle, //kConsentPageTextStyle
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            'DOB: ',
                            style: kConsentNameTextStyle,
                          ),
                          Text(
                            '11/05/1992',
                            style: kConsentNameTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '98975  ',
                            style: kConsentNumberTextStyle,
                          ),
                          Flexible(
                            child: Text(
                              'INITIAL SET UP & PATIENT EDUCATION ON THE RTM DEVICE',
                              style: kConsentPageTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '98977  ',
                            style: kConsentNumberTextStyle,
                          ),
                          Flexible(
                            child: Text(
                              'DAILY SCHEDULED/PROGRAMMED ALERT TRANSMISSION TO MONITOR MUSCULOSKELETAL SYSTEM, EACH 30 DAYS',
                              style: kConsentPageTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '98980  ',
                            style: kConsentNumberTextStyle,
                          ),
                          Flexible(
                            child: Text(
                              'CLINICAL STAFF SPENT OVER 20 MIN DURING THE CALENDAR MONTH',
                              style: kConsentPageTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '98981  ',
                            style: kConsentNumberTextStyle,
                          ),
                          Flexible(
                            child: Text(
                              'CLINICAL STAFF SPENT OVER 40 MIN DURING THE CALENDAR MONTH',
                              style: kConsentPageTextStyle,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(1, 20, 1, 20),
                        child: Table(
                          border:
                              TableBorder.all(color: Colors.black, width: 1.3),
                          columnWidths: {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: ktableColor),
                              children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Center(
                                      child: Text(
                                    'ICD 10',
                                    style: kConsentTableTextStyle,
                                  )),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Center(
                                      child: Text(
                                    'Description',
                                    style: kConsentTableTextStyle,
                                  )),
                                )),
                              ],
                            ),
                            for (var item in items)
                              TableRow(
                                decoration: BoxDecoration(color: ktableColor),
                                children: [
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      item.heading,
                                      style: kConsentTableTextStyle,
                                    )),
                                  )),
                                  TableCell(
                                      child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        item.subheading,
                                        style: kConsentsubHeadTextStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                            style: kConsentPageTextStyle,
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "Remote Therapeutic Monitoring (“RTM”) ",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,decoration: TextDecoration.underline,)),
                              TextSpan(
                                  text:
                                      "RTM refers to the use of medical devices to monitor a patient's health or response to treatment using non-physiological data. RTM can be used to monitor medication adherence, response to therapy, musculoskeletal activity, and respiratory activity. This means that RTM can be used, for example, to monitor treatment specific to pain, functional status, and adherence and response to therapy. "),
                              TextSpan(
                                  text:
                                      "IF YOU DO NOT UNDERSTAND OR AGREE TO ANY OR ALL OF THE ITEMS BELOW, PLEASE DO NOT SIGN THIS CONSENT FORM.",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ]),
                      ),
                      Column(
                        children: bullets.map((bullet) {
                          return ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "• ",
                                  style: kConsentNameTextStyle,
                                ),
                                bullet.contains('CALL 911 IMMEDIATELY')
                                    ? Flexible(
                                        child: Text.rich(
                                          TextSpan(
                                            text:
                                                'You are responsible for all applicable copay and deductible amounts (including, if you are a Medicare beneficiary, the 20% copay for Part B services); RTM services are NOT emergency services and your data WILL NOT BE MONITORED 24/7. If you think you are experiencing a medical emergency, ',
                                            style: kConsentPageTextStyle,
                                            children: [
                                              TextSpan(
                                                text: 'CALL 911 IMMEDIATELY',
                                                style: kUnderlineTextStyle,
                                              ),
                                              TextSpan(
                                                text: ' .',
                                                style: kConsentNameTextStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Flexible(
                                        child: Text.rich(
                                          TextSpan(
                                            text: bullet,
                                            style: kConsentPageTextStyle,
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      Text(
                          "By signing below, you acknowledge that you have read, understand, and agree to all of the above and you consent to receive RTM services from your healthcare provider.", //Modified RPM to RTM 30 Oct
                          style: kConsentPageTextStyle),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "Patient's Name: ",
                            style: kConsentNameTextStyle,
                          ),
                          Text(
                            'Vivek Kumar',
                            style: kConsentNameTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "Provider’s Name: ",
                            style: kConsentNameTextStyle,
                          ),
                          Text(
                            'Vivek Kumar',
                            style: kConsentNameTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "Enrolling Clinical Staff: ",
                            style: kConsentNameTextStyle,
                          ),
                          Text(
                            'Vivek Kumar',
                            style: kConsentNameTextStyle,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.all(20),
                      child: ElevatedButton(
                        child: Text('Disagree'),
                        onPressed: () async {
                          await this.widget.appManager.clearLoggedIn();
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/obs', (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                            // backgroundColor: kDisagreeBtnColor,
                            textStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.all(20),
                      child: ElevatedButton(
                        child: Text('Agree'),
                        onPressed: () {
                          acceptPatientConsent();
                          // Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            // backgroundColor: kAgreeBtnColor,
                            textStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Item {
  final String heading;
  final String subheading;

  Item(this.heading, this.subheading);
}
