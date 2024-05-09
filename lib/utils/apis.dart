import 'dart:convert';
import 'dart:io';
import 'package:Dating/constants/styles.dart';
import 'package:Dating/integrated/Register/passportDetails.dart';
import 'package:Dating/json/forgotResponse.dart';
import 'package:Dating/json/getAcademic.dart';
import 'package:Dating/json/getApplyJob.dart';
import 'package:Dating/json/getBulkResumePost.dart';
import 'package:Dating/json/getCargo.dart';
import 'package:Dating/json/getCertificate.dart';
import 'package:Dating/json/getCertificateCompetency.dart';
import 'package:Dating/json/getCity.dart';
import 'package:Dating/json/getCompany.dart';
import 'package:Dating/json/getCountry.dart';
import 'package:Dating/json/getCountryCode.dart';
import 'package:Dating/json/getCourse.dart';
import 'package:Dating/json/getCourseSelected.dart';
import 'package:Dating/json/getEngine.dart';
import 'package:Dating/json/getLevel.dart';
import 'package:Dating/json/getNationality.dart';
import 'package:Dating/json/getPassport.dart';
import 'package:Dating/json/getProfileExperience.dart';
import 'package:Dating/json/getRank.dart';
import 'package:Dating/json/getRanks.dart';
import 'package:Dating/json/getSeaExperience.dart';
import 'package:Dating/json/getSeaman.dart';
import 'package:Dating/json/getShip.dart';
import 'package:Dating/json/getShipping.dart';
import 'package:Dating/json/getSingleCompany.dart';
import 'package:Dating/json/getSingleShipping.dart';
import 'package:Dating/json/getState.dart';
import 'package:Dating/json/jobSearch.dart';
import 'package:Dating/json/login-json.dart';
import 'package:Dating/json/getPersonal.dart';
import 'package:Dating/json/registerPersonalDetails.dart';
import 'package:Dating/json/viewedCompany.dart';
import 'package:Dating/utils/appManager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Apis {
  AppManager appManager;

  Apis(this.appManager);

  //Forgot Password
  Future<ForgotResponse> sendPostRequest(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/forgot_password';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        // "Authorization": "Bearer $bearerToken",
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    // if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    //   return ForgotResponse.fromJson(jsonResponse);
    // } else {
    //   throw Exception("Failed to forgot password");
    // }
    ForgotResponse profileResp = ForgotResponse.fromJson(jsonResponse);
    return profileResp;
  }
//Register(Personal Details)

  Future<RegisterPersonalDetails> sendRegister(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/register';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        // "Authorization": "Bearer $bearerToken",
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    RegisterPersonalDetails profileResp =
        RegisterPersonalDetails.fromJson(jsonResponse);
    return profileResp;
  }

  Future<RegisterPersonalDetails> sendCourse(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/course_submit';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        // "Authorization": "Bearer $bearerToken",
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    RegisterPersonalDetails profileResp =
        RegisterPersonalDetails.fromJson(jsonResponse);
    return profileResp;
  }

   Future<GetCountry> getCountry(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/getcountry';
    var response = await http.get(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },);
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetCountry profileResp =
        GetCountry.fromJson(jsonResponse);
    return profileResp;
  }

  Future<GetNationality> getNationality(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/nationality';
    var response = await http.get(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },);
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetNationality profileResp =
        GetNationality.fromJson(jsonResponse);
    return profileResp;
  }

  Future<GetState> getState(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/getstate';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        // "Authorization": "Bearer $bearerToken",
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetState profileResp =
        GetState.fromJson(jsonResponse);
    return profileResp;
  }

   Future<GetCity> getCity(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/getcity';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        // "Authorization": "Bearer $bearerToken",
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetCity profileResp =
        GetCity.fromJson(jsonResponse);
    return profileResp;
  }

  Future<GetCertificate> getCertificate(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/certificate';
    var response = await http.get(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },);
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetCertificate profileResp =
        GetCertificate.fromJson(jsonResponse);
    return profileResp;
  }

  Future<GetRanks> getRank(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/ranks';
    var response = await http.get(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },);
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetRanks profileResp =
        GetRanks.fromJson(jsonResponse);
    return profileResp;
  }

  Future<GetShip> getShip(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/ship';
    var response = await http.get(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },);
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetShip profileResp =
        GetShip.fromJson(jsonResponse);
    return profileResp;
  }

  Future<GetEngine> getEngine(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/engine';
    var response = await http.get(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },);
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetEngine profileResp =
        GetEngine.fromJson(jsonResponse);
    return profileResp;
  }

  Future<GetCourse> getCourse(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/course';
    var response = await http.get(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },);
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetCourse profileResp =
        GetCourse.fromJson(jsonResponse);
    return profileResp;
  }

  Future<GetLevel> getLevel(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/level';
    var response = await http.get(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },);
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetLevel profileResp =
        GetLevel.fromJson(jsonResponse);
    return profileResp;
  }

  Future<GetRanks> getRanks(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/ranks';
    var response = await http.get(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },);
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetRanks profileResp =
        GetRanks.fromJson(jsonResponse);
    return profileResp;
  }

  //Dashboard Get All Data
  Future<LoginResponse?> getDashboardRequest(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/user_details';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('Dashboard uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    LoginResponse? profileResp = LoginResponse?.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Personal Data
  Future<PersonalResponse?> getPersonal(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/personal_details';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('Personal uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    PersonalResponse? profileResp = PersonalResponse?.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Passport Details
  Future<PassportResponse?> getPassport(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/passport_details';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('Passport uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    PassportResponse? profileResp = PassportResponse?.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Seaman Details
  Future<SeamanResponse?> getSeaman(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/book_details';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('Seaman uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    SeamanResponse? profileResp = SeamanResponse?.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Single Seaman Details
  Future<SeamanResponse?> getSingleSeaman(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/single_book_details';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('Seaman uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    SeamanResponse? profileResp = SeamanResponse?.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Academic Details
  Future<AcademicResponse?> getAcademic(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/academic_details';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('Academic uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    AcademicResponse? profileResp = AcademicResponse?.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Certificate Details
  Future<CertificateCompetencyResponse?> getCertificateCompetency(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/certificate_list';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('Certificate Competency uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    CertificateCompetencyResponse? profileResp = CertificateCompetencyResponse?.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Single Certificate Details
  Future<CertificateCompetencyResponse?> getSingleCertificateCompetency(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/single_certificate';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('Certificate Competency uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    CertificateCompetencyResponse? profileResp = CertificateCompetencyResponse?.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Sea Experience Details
  Future<SeaExperienceResponse?> getSeaExperienceDetails(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/experience_list';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('Sea Experience uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    SeaExperienceResponse? profileResp = SeaExperienceResponse?.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Sea Single Experience Details
  Future<SeaExperienceResponse?> getSingleSeaExperienceDetails(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/single_experience';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('Sea Experience uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    SeaExperienceResponse? profileResp = SeaExperienceResponse?.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Profile Experience Details
  Future<ProfileExperienceResponse?> getProfileExperienceDetails(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/experience_rank';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('Seaman uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    ProfileExperienceResponse? profileResp = ProfileExperienceResponse?.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Apply Job Details
  Future<ApplyJobResponse?> getjobDetails(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/apply_rank';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('Seaman uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    ApplyJobResponse? profileResp = ApplyJobResponse?.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Course Details
  Future<CourseSelectedResponse?> getCourseDetails(
     Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/course_details';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('course uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    CourseSelectedResponse? profileResp = CourseSelectedResponse?.fromJson(jsonResponse);
    return profileResp;
  }

  //Update Course Details
  Future<RegisterPersonalDetails> updateCourse(
     Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/course_update';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('course uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    RegisterPersonalDetails profileResp = RegisterPersonalDetails.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Profile Experience Details
  Future<DangerousCargoResponse?> getCargoEndorementDetails(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/dce_details';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('DangerousCargo uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    DangerousCargoResponse? profileResp = DangerousCargoResponse?.fromJson(jsonResponse);
    return profileResp;
  }
  //Update DCE Details
  Future<RegisterPersonalDetails> updateDCE(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/info_update';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    RegisterPersonalDetails profileResp =
        RegisterPersonalDetails.fromJson(jsonResponse);
    return profileResp;
  }
  //Update Register
  Future<RegisterPersonalDetails> updateRegister(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/register';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    RegisterPersonalDetails profileResp =
        RegisterPersonalDetails.fromJson(jsonResponse);
    return profileResp;
  }

  //Logout
  Future<RegisterPersonalDetails> logout(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/logout';
    var response = await http.get(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        );
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    RegisterPersonalDetails profileResp =
        RegisterPersonalDetails.fromJson(jsonResponse);
    return profileResp;
  }

  //Job Search in Dashboard
  Future<JobSearch?> searchJob(
     Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/job_search';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('job search dashboard uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    JobSearch? profileResp = JobSearch?.fromJson(jsonResponse);
    return profileResp;
  }
  //Get company detail of search job
  Future<SingleCompany?> singlesearchJob(
     Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/company_details';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('job search dashboard uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    SingleCompany? profileResp = SingleCompany?.fromJson(jsonResponse);
    return profileResp;
  }


  //Job Search in Dashboard
  Future<RegisterPersonalDetails> applyjobdetails(
     Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/search_job';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('apply job details dashboard uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    RegisterPersonalDetails profileResp = RegisterPersonalDetails.fromJson(jsonResponse);
    return profileResp;
  }

  //Reset Password
  Future<ForgotResponse> resetPassword(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/change_password';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    ForgotResponse profileResp = ForgotResponse.fromJson(jsonResponse);
    return profileResp;
  }
  //Get Company Lists
  Future<GetCompany> getCompany(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/unhide_hide_companylist';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
           "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetCompany profileResp =
        GetCompany.fromJson(jsonResponse);
    return profileResp;
  }

  Future<RegisterPersonalDetails> hideunhide(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/unhide_hide_company';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        }, 
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    RegisterPersonalDetails profileResp =
        RegisterPersonalDetails.fromJson(jsonResponse);
    return profileResp;
  }

  //Get company detail of shipping company
  Future<SingleShipping?> companydetail(
     Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/ship_company_by_id';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('job search dashboard uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    SingleShipping? profileResp = SingleShipping?.fromJson(jsonResponse);
    return profileResp;
  }


  //Get Sea Experience Details
  Future<RegisterPersonalDetails?> deleteSeaExperience(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/delete_experience';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('Delete Sea Experience uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    RegisterPersonalDetails? profileResp = RegisterPersonalDetails?.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Company Lists
  Future<GetShippingCompany> shippingCompany(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/shipping_company';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
           "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetShippingCompany profileResp =
        GetShippingCompany.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Company Lists
  Future<ViewedCompany?> getViewedCompany(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/viewed_by_company';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
           "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    ViewedCompany? profileResp =
        ViewedCompany?.fromJson(jsonResponse);
    return profileResp;
  }

  Future<GetBulkResumePost> getBulkResume(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/ship_company';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
         body: jsonEncode(requestBody));
    
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetBulkResumePost profileResp =
        GetBulkResumePost.fromJson(jsonResponse);
    return profileResp;
  }

  Future<GetBulkResumePost> getJobCompany(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/ship_company_list';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
         body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetBulkResumePost profileResp =
        GetBulkResumePost.fromJson(jsonResponse);
    return profileResp;
  }

  //Job Search in Dashboard
  Future<RegisterPersonalDetails> applyJobResume(
     Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/bulk_resume_post';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: jsonEncode(requestBody));
    print('apply job resume details uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    RegisterPersonalDetails profileResp = RegisterPersonalDetails.fromJson(jsonResponse);
    return profileResp;
  }

  //Get Country Code
   Future<GetCountryCode> getCountryCode(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/getphonecode';
    var response = await http.get(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },);
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    GetCountryCode profileResp =
        GetCountryCode.fromJson(jsonResponse);
    return profileResp;
  }



























//   /* REST APIs */

//   Future<SendMessageByPatient> sendMessageByPatientWithFile(
//       String msg, String attachmentType, File file) async {
//     var response = await this.appManager.postFile(
//         "${this.appManager.serverURL}/api/uploadMsgAttachment",
//         {"msg": msg, "attachmentType": attachmentType},
//         file);
//     print("upload file response $response");
//     SendMessageByPatient profileResp =
//         SendMessageByPatient.fromJson(json.decode(response));
//     return profileResp;
//   }

//   Future<FileUpload> updateProfilePicture(File file) async {
//     var response = await this.appManager.postFile(
//         "${this.appManager.serverURL}/api/updatePatientPhoto", {}, file);
//     FileUpload profileResp = FileUpload.fromJson(json.decode(response));
//     return profileResp;
//   }

  Future<void> updateProfileData(String sId,
      {String? primaryDoctorName,
      String? primaryDoctorMobile,
      String? emergencyContactPersonName,
      num? emergencyContactPersonPhone,
      String? emergencyContactPersonRelation}) async {
    var resp = await this
        .appManager
        .send("patient->updatePatientPersonalInformationByPatient", {
      "args": {"_id": sId},
      "data": {
        if (emergencyContactPersonName != null)
          "emergencyContactPersonName": emergencyContactPersonName,
        if (emergencyContactPersonRelation != null)
          "emergencyContactPersonRelation": emergencyContactPersonRelation,
        if (emergencyContactPersonPhone != null)
          "emergencyContactPersonPhone": emergencyContactPersonPhone,
        if (primaryDoctorName != null) "primaryDoctorName": primaryDoctorName,
        if (primaryDoctorMobile != null)
          "primaryDoctorMobile": primaryDoctorMobile
      }
    });
  }
}
