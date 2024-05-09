import 'package:Dating/constants/styles.dart';
import 'package:Dating/json/getCity.dart';
import 'package:Dating/json/getCountry.dart';
import 'package:Dating/json/getCountryCode.dart';
import 'package:Dating/json/getState.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactDetails extends StatefulWidget {
  ContactDetails(
      {Key? key,
      required this.title,
      required this.appManager,
      required this.updateBtn})
      : super(key: key);

  final String title;
  final AppManager appManager;
  final bool updateBtn;

  @override
  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  bool isChecked = false;
  late FToast fToast;
  late SharedPreferences prefs;
  late List<Country> countries;
  late List<GState> statesList;
  late List<City> cityList;
  late List<CountryCode> countriesCode;
  String cityId = '';
  String stateId = '';
  String user_id = '';
  String countryId = '';
  bool isTapped = true;
  List<String> texts = [
    'Address',
    'Country',
    'State',
    'City',
    'Pin Code',
    'Phone',
    'Mobile No.',
    'Email',
    'Alternate Number',
    'Whatsapp Number',
  ];

  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _alternateController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _whattsController = TextEditingController();
  TextEditingController _phonecountry = TextEditingController();
  TextEditingController _mobilecountry = TextEditingController();
  TextEditingController _alternatecountry = TextEditingController();
  TextEditingController _whattscountry = TextEditingController();
  String token = '';

  void _showDropdown(BuildContext context, String type) {
    List<dynamic> items = [];
    String placeholder = '';
    switch (type) {
      case 'Country':
        items = countries;
        placeholder = 'Search country...';
        break;
      case 'State':
        items = statesList;
        placeholder = 'Search state...';
        break;
      case 'City':
        items = cityList;
        placeholder = 'Search city...';
        break;
      case 'C1':
      case 'C2':
      case 'C3':
      case 'C4':
        items = countriesCode;
        placeholder = 'Search code...';
        break;
      default:
        break;
    }

    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        TextEditingController searchController = TextEditingController();

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
                        hintText: placeholder,
                      ),
                      onChanged: (value) {
                        setState(() {}); // Trigger rebuild on text change
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final String itemName = type == 'Country'
                            ? item.name
                            : type == 'State'
                                ? item.name
                                : type == 'City'
                                    ? item.name
                                    : '+' + item.locationId + ' ' + item.name;
                        // Check if the item matches the search query
                        final bool matchesSearch = itemName
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase());
                        // Show item only if it matches search query
                        if (!matchesSearch) return SizedBox.shrink();

                        return ListTile(
                          title: Text(
                            itemName,
                            style: kDropDownTextStyle,
                          ),
                          onTap: () {
                            setState(() {
                              if (type == 'Country') {
                                _countryController.text = item.name;
                                countryId = item.locationId;
                                getState(item.locationId);
                              } else if (type == 'State') {
                                _stateController.text = item.name;
                                stateId = item.locationId;
                                getCity(item.locationId);
                              } else if (type == 'City') {
                                _cityController.text = item.name;
                                cityId = item.locationId;
                              } else if (type == 'C1') {
                                _phonecountry.text = item.locationId;
                              } else if (type == 'C2') {
                                _mobilecountry.text = item.locationId;
                              } else if (type == 'C3') {
                                _alternatecountry.text = item.locationId;
                              } else if (type == 'C4') {
                                _whattscountry.text = item.locationId;
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

  Future<void> submitContactDetails() async {
    String user_id = prefs.getString('sId') ?? '';
    final requestBody = {
      'page': '2',
      'user_id': user_id,
      'address': _addressController.text,
      'city': cityId,
      'state': stateId,
      'country': countryId,
      'pincode': _pincodeController.text,
      'mobile': _mobileController.text,
      'email': _emailController.text,
      'mobile2': _alternateController.text,
      'phone': _phoneController.text,
      'whatsappno': _whattsController.text,
      'phone_country': _phonecountry.text,
      'mobile_country': _mobilecountry.text,
      'mobile2_country': _alternatecountry.text,
      'whatsapp_country': _whattscountry.text,
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
        print("Failed to submit contact details");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to submit contact details: $error");
    });
  }

  Future<void> updateContactDetails() async {
    String user_id = prefs.getString('sId') ?? '';
    final requestBody = {
      'page': '2',
      'user_id': user_id,
      'address': _addressController.text,
      'city': cityId,
      'state': stateId,
      'country': countryId,
      'pincode': _pincodeController.text,
      'mobile': _mobileController.text,
      'email': _emailController.text,
      'mobile2': _alternateController.text,
      'phone': _phoneController.text,
      'whatsappno': _whattsController.text,
      'phone_country': _phonecountry.text,
      'mobile_country': _mobilecountry.text,
      'mobile2_country': _alternatecountry.text,
      'whatsapp_country': _whattscountry.text,
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
        print("Failed to submit contact details");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to submit contact details: $error");
    });
  }

  Future<void> getContactDetails(String user_id) async {
    if (user_id != "") {
      final requestBody = {"user_id": user_id};
      widget.appManager.apis
          .getPersonal(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) async {
        // Handle successful response
        if (response?.status == 200) {
          //Success
          // prefs.setString('sId', response?.user?.id ?? '');
          // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
          setState(() {
            _addressController.text = response?.user?.address ?? '';
            _countryController.text = response?.user?.countryName ?? '';
            countryId = response?.user?.country ?? '';
            _stateController.text = response?.user?.stateName ?? '';
            stateId = response?.user?.state ?? '';
            _cityController.text = response?.user?.cityName ?? '';
            cityId = response?.user?.city ?? '';
            _pincodeController.text = response?.user?.zipcode ?? '';
            _phoneController.text = response?.user?.phone ?? '';
            _mobileController.text = response?.user?.mobile ?? '';
            _alternateController.text = response?.user?.mobile2 ?? '';
            _emailController.text = response?.user?.email ?? '';
            _whattsController.text = response?.user?.whatts ?? '';
            _phonecountry.text = response?.user?.pcountry ?? '91';
            _mobilecountry.text = response?.user?.mcountry ?? '91';
            _alternatecountry.text = response?.user?.m2country ?? '91';
            _whattscountry.text = response?.user?.wcountry ?? '91';
            isChecked = true;
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
          print("Failed to get contact data");
        }
      }).catchError((error) {
        // Handle error
        print("Failed to get contact data: $error");
      });
    } else {
      showToast('Please get user_id', 2, kToastColor, context);
    }
  }

  Future<void> getCountry() async {
    final requestBody = {"": ''};
    widget.appManager.apis
        .getCountry(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        _phonecountry.text = '91';
        _mobilecountry.text = '91';
        _alternatecountry.text = '91';
        _whattscountry.text = '91';
        countries = response.country;
        //  Navigator.pushReplacementNamed(context, '/login');
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to get country");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get country: $error");
    });
  }

  Future<void> getCountryCode() async {
    final requestBody = {"": ''};
    widget.appManager.apis
        .getCountryCode(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        countriesCode = response.country;
        //  Navigator.pushReplacementNamed(context, '/login');
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to get country");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get country: $error");
    });
  }

  Future<void> getState(String county_id) async {
    final requestBody = {"country_id": county_id};
    widget.appManager.apis
        .getState(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        statesList = response.states;
        //  Navigator.pushReplacementNamed(context, '/login');
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to get state");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get state: $error");
    });
  }

  Future<void> getCity(String state_id) async {
    final requestBody = {"state_id": state_id};
    widget.appManager.apis
        .getCity(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        // showToast(response?.message ?? '', 2, kPositiveToastColor, context);
        cityList = response.cities;
        //  Navigator.pushReplacementNamed(context, '/login');
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to get city");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get city: $error");
    });
  }

  bool isValidForm() {
    final emailPattern = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (_addressController.text == '') {
      showToast('Please enter address', 2, kToastColor, context);
      return false;
    } else if (_countryController.text == '') {
      showToast('Please select country', 2, kToastColor, context);
      return false;
    } else if (_stateController.text == '') {
      showToast('Please select state', 2, kToastColor, context);
      return false;
    } else if (_cityController.text == '') {
      showToast('Please select city', 2, kToastColor, context);
      return false;
    } else if (_pincodeController.text == '' || _pincodeController.text.length < 6) {
      showToast('Please enter pincode of atleast 6 characters', 2, kToastColor, context);
      return false;
    } else if (_phonecountry.text.length < 1) {
      showToast(
          'Please enter country code of phone number', 2, kToastColor, context);
      return false;
    } else if (_phoneController.text == '' ||
        _phoneController.text.length < 10) {
      showToast('Please enter phone number', 2, kToastColor, context);
      return false;
    } else if (_mobilecountry.text.length < 1) {
      showToast('Please enter country code of mobile number', 2, kToastColor,
          context);
      return false;
    } else if (_mobileController.text == '' ||
        _mobileController.text.length < 10) {
      showToast('Please enter mobile number', 2, kToastColor, context);
      return false;
    } else if (!(emailPattern.hasMatch(_emailController.text))) {
      showToast('Please enter email address', 2, kToastColor, context);
      return false;
    } else if (_alternatecountry.text.length < 1 &&
        _alternateController.text != '') {
      showToast('Please enter country code of alternate number', 2, kToastColor,
          context);
      return false;
    } else if (_whattscountry.text.length < 1) {
      showToast('Please enter country code of whattsapp number', 2, kToastColor,
          context);
      return false;
    } else if (_whattsController.text == '' ||
        _whattsController.text.length < 10) {
      showToast('Please enter whatsapp number', 2, kToastColor, context);
      return false;
    } else if (isChecked == false) {
      setState(() {
        isTapped = false;
      });
      showToast('Please accept for magazine and pro-activity on WhatsApp', 2,
          kRejectButtonColor, context);
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
                      ? "Your information has been updated successfully."
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
                          : Navigator.pushNamed(context, "/passport",
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // this.jumpToHomeIfRequired();
    countries = [];
    statesList = [];
    cityList = [];
    countriesCode = [];
    getPrefs();
    fToast = FToast();
    fToast.init(context);
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('authToken') ?? '';
    user_id = prefs.getString('sId') ?? '';
    getCountry();
    getCountryCode();
    widget.updateBtn ? getContactDetails(user_id) : null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //  _showAlertDialog(context);
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
              'Contact Details',
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
                          // scrollDirection: Axis.vertical,
                          itemCount: texts
                              .length, // Change this number as per your requirement
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
                                      if (index == 5 ||
                                          index == 6 ||
                                          index == 8 ||
                                          index == 9)
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: Container(
                                            width: 100,
                                            margin: EdgeInsets.only(bottom: 12),
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
                                                  Icons.numbers,
                                                  size: 20,
                                                  color: kLoginIconColor,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  '+',
                                                  style: kLoginTextFieldLabel,
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    controller: index == 5
                                                        ? _phonecountry
                                                        : index == 6
                                                            ? _mobilecountry
                                                            : index == 8
                                                                ? _alternatecountry
                                                                : _whattscountry,
                                                    // controller: TextEditingController(text: "+91"),
                                                    onTapAlwaysCalled: true,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      isDense: true,
                                                      hintText: 'Code',
                                                      hintStyle:
                                                          kLoginTextFieldTextStyle,
                                                    ),
                                                    onTap: () {
                                                      index == 5
                                                          ? _showDropdown(
                                                              context, 'C1')
                                                          : index == 6
                                                              ? _showDropdown(
                                                                  context, 'C2')
                                                              : index == 8
                                                                  ? _showDropdown(
                                                                      context,
                                                                      'C3')
                                                                  : _showDropdown(
                                                                      context,
                                                                      'C4');
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 12),
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
                                                index == 0
                                                    ? Icons.house_outlined
                                                    : index == 5 ||
                                                            index == 6 ||
                                                            index == 8
                                                        ? Icons.call
                                                        : index == 7
                                                            ? Icons
                                                                .email_outlined
                                                            : index == 1
                                                                ? Icons
                                                                    .map_outlined
                                                                : index == 2 ||
                                                                        index ==
                                                                            3 ||
                                                                        index ==
                                                                            4
                                                                    ? Icons
                                                                        .pin_drop_outlined
                                                                    : Icons
                                                                        .chat,
                                                size: 20,
                                                color: kLoginIconColor,
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: TextFormField(
                                                  maxLines: 1,
                                                  keyboardType: index == 7
                                                      ? TextInputType
                                                          .emailAddress
                                                      : index == 6 ||
                                                              index == 8 ||
                                                              index == 5 ||
                                                              index == 9
                                                          ? TextInputType.number
                                                          : index == 4
                                                              ? TextInputType
                                                                  .number
                                                              : TextInputType
                                                                  .text,
                                                  readOnly: index == 1 ||
                                                          index == 2 ||
                                                          index == 3
                                                      ? true
                                                      : false,
                                                  controller: index == 1
                                                      ? _countryController
                                                      : index == 2
                                                          ? _stateController
                                                          : index == 3
                                                              ? _cityController
                                                              : index == 0
                                                                  ? _addressController
                                                                  : index == 4
                                                                      ? _pincodeController
                                                                      : index ==
                                                                              5
                                                                          ? _phoneController
                                                                          : index == 6
                                                                              ? _mobileController
                                                                              : index == 7
                                                                                  ? _emailController
                                                                                  : index == 8
                                                                                      ? _alternateController
                                                                                      : _whattsController,
                                                  onTapAlwaysCalled: true,
                                                  inputFormatters: index == 6 ||
                                                          index == 5 ||
                                                          index == 8 ||
                                                          index == 9
                                                      ? [
                                                          LengthLimitingTextInputFormatter(
                                                              12)
                                                        ]
                                                      : index == 4
                                                          ? [
                                                              LengthLimitingTextInputFormatter(
                                                                  6)
                                                            ]
                                                          : [
                                                              LengthLimitingTextInputFormatter(
                                                                  200)
                                                            ],
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    isDense: true,
                                                    hintText: '${texts[index]}',
                                                    hintStyle:
                                                        kLoginTextFieldTextStyle,
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      index == 0
                                                          ? _addressController
                                                              .text = value
                                                          : index == 4
                                                              ? _pincodeController
                                                                  .text = value
                                                              : index == 6
                                                                  ? _mobileController
                                                                          .text =
                                                                      value
                                                                  : index == 5
                                                                      ? _phoneController
                                                                              .text =
                                                                          value
                                                                      : index ==
                                                                              7
                                                                          ? _emailController.text =
                                                                              value
                                                                          : index == 8
                                                                              ? _alternateController.text = value
                                                                              : _whattsController.text = value;
                                                    });
                                                  },
                                                  onTap: () {
                                                    index == 1
                                                        ? _showDropdown(
                                                            context, 'Country')
                                                        : index == 2
                                                            ? _showDropdown(
                                                                context,
                                                                'State')
                                                            : index == 3
                                                                ? _showDropdown(
                                                                    context,
                                                                    'City')
                                                                : null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        height: 950,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            //  padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isTapped ? Colors.transparent : isChecked ? Colors.transparent  : Colors.red, // Border color
                                width: 2.0, // Border width
                              ),
                              borderRadius:
                                  BorderRadius.circular(2.0), // Border radius
                            ),
                            child: Checkbox(
                              activeColor: kButtonColor,
                              focusColor: kButtonColor,
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value ?? false;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: Text(
                              'I agree, to get magazine and pro-activity on WhatsApp',
                              style: kReqTimeSlotTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
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
                              widget.updateBtn == true ? 'Update' : 'Next',
                              style: kButtonTextStyle),
                          onPressed: () {
                            if (isValidForm()) {
                              widget.updateBtn
                                  ? updateContactDetails()
                                  : submitContactDetails();
                            }
                            //  Navigator.pushNamed(context, "/passport");
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
