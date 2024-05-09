import 'package:Dating/integrated/BulkResumePost/bulkApplyJob.dart';
import 'package:Dating/integrated/BulkResumePost/bulkResumePost.dart';
import 'package:Dating/integrated/Job/jobDetails.dart';
import 'package:Dating/integrated/Job/jobListing.dart';
import 'package:Dating/integrated/Job/searchJob.dart';
import 'package:Dating/integrated/Profile/editCertificationOfCompetency.dart';
import 'package:Dating/integrated/Profile/editPersonalDetails.dart';
import 'package:Dating/integrated/Profile/editSeaExperienceDetails.dart';
import 'package:Dating/integrated/Profile/editSeamanDetails.dart';
import 'package:Dating/integrated/Profile/myProfile.dart';
import 'package:Dating/integrated/Profile/editAcademicDetails.dart';
import 'package:Dating/integrated/Register/academicDetails.dart';
import 'package:Dating/integrated/Register/applyJob.dart';
import 'package:Dating/integrated/Register/certificationOfCompetency.dart';
import 'package:Dating/integrated/Register/contactDetails.dart';
import 'package:Dating/integrated/Register/coursesDetails.dart';
import 'package:Dating/integrated/Register/dangerousCargoEndorsement.dart';
import 'package:Dating/integrated/Register/passportDetails.dart';
import 'package:Dating/integrated/Register/profileandtotalExperience.dart';
import 'package:Dating/integrated/Register/seaExperienceDetails.dart';
import 'package:Dating/integrated/Register/seamanBookDetails.dart';
import 'package:Dating/integrated/Register/terms_condition.dart';
import 'package:Dating/integrated/Register/thankYou.dart';
import 'package:Dating/integrated/Shipping/shippingCompanyDetails.dart';
import 'package:Dating/integrated/consent.dart';
import 'package:Dating/integrated/dashboardScreen.dart';
import 'package:Dating/integrated/forgetPassword.dart';
import 'package:Dating/integrated/hideCompany.dart';
import 'package:Dating/integrated/login.dart';
import 'package:Dating/integrated/loginRegister.dart';
import 'package:Dating/integrated/notifications.dart';
import 'package:Dating/integrated/onboarding/initial.dart';
import 'package:Dating/integrated/Register/personalDetails.dart';
import 'package:Dating/integrated/onboarding/onboarding.dart';
import 'package:Dating/integrated/onboarding/welcomeScreen.dart';
import 'package:Dating/integrated/resetPassword.dart';
import 'package:Dating/integrated/Shipping/shippingCompany.dart';
import 'package:Dating/integrated/viewedByCompany.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/material.dart';
//added on 29 Feb
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // var values = await Firebase.initializeApp();
  // print("values firebase $values");
  SharedPreferences pref = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: pref));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;
  @override
  _MyAppState createState() => _MyAppState();
}

 class _MyAppState extends State<MyApp> {
  late AppManager appManager;
  Map<String, dynamic> routes = {};
  @override
  Widget build(BuildContext context) {
    
    this.routes = {
      //integrated routes
       '/': (context) =>
          InitialScreen(title: 'SplashScreen', appManager: appManager),
          '/obs': (context) => Onboarding(),
      '/login': (context) => Login(title: 'Log - in', appManager: appManager),
      '/forgetPassword': (context) =>
          ForgetPassword(title: 'Forget Password', appManager: appManager),
      '/personal': (context) => PersonalDetails(title: 'Personal Details', appManager: appManager),
      '/academic': (context) => AcademicDetails(title: 'Academic Details', appManager: appManager),
      '/terms': (context) => TermsCondition(title: 'Terms & Conditions', appManager: appManager),
      //Edit Data
      '/thank': (context) => ThankYou(title: 'Thank You', appManager: appManager),
      '/profile': (context) =>
          MyProfile(title: 'My Profile', appManager: appManager),
      //Profile
      '/searchjob': (context) =>
          SearchJob(title: 'Search Job', appManager: appManager),
      '/resetPassword': (context) =>
          ResetPassword(title: 'Reset Password', appManager: appManager),
      '/shipcompany': (context) =>
          ShippingCompany(title: 'Shipping Companies(India)', appManager: appManager),
      '/viewedcompany': (context) =>
          ViewedByCompany(title: 'Viewed By Company', appManager: appManager),
      '/bulkresume': (context) =>
          BulkResumePost(title: 'Bulk Resume Post', appManager: appManager),
       '/start': (context) =>
          ForgetPassword(title: 'Forget Password', appManager: appManager),
        '/notif': (context) => Notifications(title: 'Activity', appManager: appManager),
        '/consent': (context) => Consent(title: 'Activity', appManager: appManager)
    };

    return MaterialApp(
        title: 'Dating App',
        // debugShowCheckedModeBanner: false,
        onGenerateRoute: _getRoute,
        theme: ThemeData(
          // primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        builder: (context, child) {
          this.widget.prefs.setDouble(
              "textScalingFactor", MediaQuery.of(context).textScaleFactor);
          return MediaQuery(
            child: child ?? Container(),
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.845),//0.97)
          );
        });
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    appManager.currentPage = settings.name ?? '';
    Widget temp;
    return PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        switch (settings.name) {
          case '/home':
            final bool someValue = settings.arguments as bool;
            temp = DashboardScreen(
                title: 'Home',
                appManager: appManager,
                isRegister: someValue,
                );
            break;
          case '/thank':
            temp = ThankYou(
                title: 'Thank You',
                appManager: appManager,
                );
            break;
          case '/editpersonal':
            final bool someValue = settings.arguments as bool;
            temp = EditPersonalDetails(
                title: 'Personal Details',
                appManager: appManager,
                updateBtn: someValue,
                );
            break;
          case '/contact':
            final bool someValue = settings.arguments as bool;
            temp = ContactDetails(
                title: 'Contact Details',
                appManager: appManager,
                updateBtn: someValue,
                );
            break;
          case '/passport':
            final bool someValue = settings.arguments as bool;
            temp = PassportDetails(
                title: 'Passport Details',
                appManager: appManager,
                updateBtn: someValue,
                );
            break;
          case '/editseaman':
            final bool someValue = settings.arguments as bool;
            temp = EditSeamanDetails(
                title: 'Seaman Book Details',
                appManager: appManager,
                updateBtn: someValue,
                );
            break;
          case '/seaman':
            final Map<String, dynamic> someValue = settings.arguments as Map<String, dynamic>;
            temp = SeamanBookDetails(
                title: 'Seaman Book Details',
                appManager: appManager,
                updateBtn: someValue,
                );
            break;
          case '/competency':
            final Map<String, dynamic> someValue = settings.arguments as Map<String, dynamic>;
            temp = CertificationOfCompetency(
                title: 'Certification Of Competency',
                appManager: appManager,
                updateBtn: someValue,
                );
            break;
          case '/editcompetency':
            final bool someValue = settings.arguments as bool;
            temp = EditCertificationOfCompetency(
                title: 'Certification Of Competency',
                appManager: appManager,
                updateBtn: someValue,
                );
            break;
          case '/editacademic':
             final bool someValue = settings.arguments as bool;
            temp = EditAcademicDetails(
                title: 'Academic Details',
                appManager: appManager,
                updateBtn: someValue,
                );
            break;
           case '/courses':
             final bool someValue = settings.arguments as bool;
            temp = CoursesDetails(
                title: 'Courses Details',
                appManager: appManager,
                updateBtn: someValue,
                );
            break;
          case '/seaexperience':
              final Map<String, dynamic> someValue = settings.arguments as Map<String, dynamic>;
            temp = SeaExperienceDetails(
                title: 'Sea Experience Details',
                appManager: appManager,
                updateBtn: someValue,
                );
            break;
           case '/editseaexperience':
              final bool someValue = settings.arguments as bool;
            temp = EditSeaExperienceDetails(
                title: 'Sea Experience Details',
                appManager: appManager,
                updateBtn: someValue,
                );
            break;
            case '/profilexperience':
              final bool someValue = settings.arguments as bool;
              temp = ProfileandtotalExperience(
                title: 'Profile And Total Experience',
                appManager: appManager,
                updateBtn: someValue,
                );
            break;
          case '/job':
              final bool someValue = settings.arguments as bool;
            temp = ApplyJob(
                title: 'Apply a Job',
                appManager: appManager,
                updateBtn: someValue,
                );
            break;
          case '/dangerous':
              final bool someValue = settings.arguments as bool;
            temp = DangerousCargoEndorsement(
                title: 'Dangerous Cargo Endorsement',
                appManager: appManager,
                updateBtn: someValue,
                );
            break;
          case '/joblisting':
               final Map<String, String> someValue = settings.arguments as Map<String, String>;
            temp = JobListing(
                title: 'Company Job Listing',
                appManager: appManager,
                data: someValue,
                );
            break;
           case '/jobdetail':
               final String someValue = settings.arguments as String;
            temp = JobDetails(
                title: 'Company Job Listing',
                appManager: appManager,
                comp_id: someValue,
                );
            break;
            case '/hidecompany':
               final String someValue = settings.arguments as String;
            temp = HideCompany(
                title: 'Hide Company',
                appManager: appManager,
                status: someValue,
                );
            break;
           case '/shipdetail':
               final String someValue = settings.arguments as String;
            temp = ShippingCompanyDetails(
                title: 'Shipping Companies(India)',
                appManager: appManager,
                comp_id: someValue,
                );
            break;
            case '/bulkapply':
               final String someValue = settings.arguments as String;
            temp = BulkApplyJob(
                title: 'Bulk Apply Job',
                appManager: appManager,
                jobid: someValue,
                );
            break;
            case '/welcome':
              final bool someValue = settings.arguments as bool;
            temp = WelcomeScreen(
                title: 'Welcome',
                appManager: appManager,
                isRegister: someValue,
                );
            break;



          default:
            temp = this.routes[settings.name](context);
        }
        this.appManager.currentPageObject = temp;
        return temp;
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }

  @override
  void initState() {
    var envMode = "prod";
    appManager = AppManager(envMode, this.widget.prefs);

    appManager.hasLoggedIn().then((result) {
      if (result['hasLoggedIn']) {
        appManager.initSocket(result['authToken']);
      }
    });
  // _launchStoreURL();
    super.initState();
  }

  void _launchStoreURL() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      // Replace 'your_package_name' with your actual package name on the Play Store
      final Uri url = Uri.parse('docuvitals://');
      if(await canLaunchUrl(url)){
          await launchUrl(url);
      }else{
      const playStorePackageName = 'com.docuvitals.health';
      final playStoreURL =
          'https://play.google.com/store/apps/details?id=$playStorePackageName';

      if (await canLaunch(playStoreURL)) {
        await launch(playStoreURL);
      } else {
        throw 'Could not launch Play Store URL';
      }
      }
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      // Replace 'your_app_id' with your actual App ID on the App Store
      final Uri url = Uri.parse('docuvitals://');
      if(await canLaunchUrl(url)){
          await launchUrl(url);
      }else{
      const appStoreID = '1554906931';
      final appStoreURL = 'https://apps.apple.com/app/$appStoreID';

      if (await canLaunch(appStoreURL)) {
        await launch(appStoreURL);
      } else {
        throw 'Could not launch App Store URL';
      }
      }
    }
  }
}