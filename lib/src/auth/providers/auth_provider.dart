// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipping_address/common/helper/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shipping_address/common/routes/route.dart';
import 'package:shipping_address/src/auth/models/contact_model.dart';
import 'package:shipping_address/src/auth/models/login_model.dart';
import 'package:shipping_address/src/auth/models/register_model.dart';
import 'package:shipping_address/src/auth/models/resend_code_model.dart';
import 'package:shipping_address/src/auth/models/verification_model.dart';

class AuthProvider extends ChangeNotifier {
  /* 
  this line of beginning public provider
  */
  TextEditingController userC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController codeC = TextEditingController();
  TextEditingController firstNameC = TextEditingController();
  TextEditingController lastNameC = TextEditingController();
  // clear all controller from auth screen
  clearTextField() {
    userC.clear();
    passwordC.clear();
    passwordC.clear();
    codeC.clear;
    firstNameC.clear;
    lastNameC.clear;
    notifyListeners();
  }
  /* 
  this line of the end public provider
  */

  /* this line of beginning login provider */
  LoginModel _loginModel = LoginModel();
  ErrorLoginModel _errorLoginModel = ErrorLoginModel();

  // fetch url login using http and from controller user and password
  Future<void> fetchLogin(BuildContext context) async {
    try {
      Uri url = Uri.parse(Constant.BASE_URL + '/customer/login');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"user_id": userC.text, "password": passwordC.text}),
      );
      final prefs = await SharedPreferences.getInstance();
      var responseBody = jsonDecode(response.body);
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          responseBody['login'] == true) {
        _loginModel = LoginModel.fromJson(jsonDecode(response.body));
        await prefs.setString(Constant.kPrefToken, _loginModel.token!);
        log(_loginModel.token!);
        notifyListeners();
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoute.listAddress,
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Selamat datang kembali ${_loginModel.customer?.firstName} ${_loginModel.customer?.lastName}',
            ),
            backgroundColor: Colors.green,
          ),
        );
        clearTextField();
      } else {
        _errorLoginModel = ErrorLoginModel.fromJson(jsonDecode(response.body));
        await prefs.remove(Constant.kPrefToken);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorLoginModel.message!),
            backgroundColor: Colors.red,
          ),
        );
        notifyListeners();
      }
    } on Exception catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }
  /*  this line of the end login provider */

  /* this line of beginning register provider */
  RegisterModel _registerModel = RegisterModel();
  ErrorRegisterModel _errorRegisterModel = ErrorRegisterModel();

  // fetch url register customer
  Future<void> fetchRegister(BuildContext context) async {
    try {
      String token = Constant.ACCESS_TOKEN;
      Uri url = Uri.parse(Constant.BASE_URL + '/customer/register/mini');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'AccessToken': token,
        },
        body: jsonEncode({"user_id": userC.text}),
      );
      log('Response Body ${response.body}');
      var responseBody = jsonDecode(response.body);
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          responseBody['action'] == true) {
        _registerModel = RegisterModel.fromJson(jsonDecode(response.body));
        Navigator.pushReplacementNamed(context, AppRoute.verification);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_registerModel.message!),
            backgroundColor: Colors.green,
          ),
        );
        notifyListeners();
      } else {
        _errorRegisterModel = ErrorRegisterModel.fromJson(
          jsonDecode(response.body),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorRegisterModel.message!),
            backgroundColor: Colors.red,
          ),
        );
        notifyListeners();
      }
    } on Exception catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }
  /* this line of the end login provider */

  /* this line of beginning verification view */
  VerificationModel _verificationModel = VerificationModel();

  Future<void> fetchVerification(BuildContext context) async {
    try {
      String token = Constant.ACCESS_TOKEN;
      Uri url = Uri.parse(Constant.BASE_URL + '/customer/register/verify-code');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'AccessToken': token,
        },
        body: jsonEncode({"user_id": userC.text, "code": codeC.text}),
      );
      log('Response Body ${response.body}');
      var responseBody = jsonDecode(response.body);
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          responseBody['action'] == true) {
        _verificationModel = VerificationModel.fromJson(
          jsonDecode(response.body),
        );
        Navigator.pushReplacementNamed(context, AppRoute.successVerification);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_verificationModel.message!),
            backgroundColor: Colors.green,
          ),
        );
        notifyListeners();
      } else {
        _verificationModel = VerificationModel.fromJson(
          jsonDecode(response.body),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_verificationModel.message!),
            backgroundColor: Colors.red,
          ),
        );
        notifyListeners();
      }
    } on Exception catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }

  /* this line of the end verification view */
  /* this line of beginning verification view */
  ResendCodeModel _resendCodeModel = ResendCodeModel();

  Future<void> fetchResendCode(BuildContext context) async {
    try {
      String token = Constant.ACCESS_TOKEN;
      Uri url = Uri.parse(Constant.BASE_URL + '/customer/register/resend-code');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'AccessToken': token,
        },
        body: jsonEncode({"user_id": userC.text}),
      );
      log('Response Body ${response.body}');
      var responseBody = jsonDecode(response.body);
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          responseBody['action'] == true) {
        _resendCodeModel = ResendCodeModel.fromJson(jsonDecode(response.body));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_resendCodeModel.message!),
            backgroundColor: Colors.green,
          ),
        );
        notifyListeners();
      } else {
        _resendCodeModel = ResendCodeModel.fromJson(jsonDecode(response.body));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_resendCodeModel.message!),
            backgroundColor: Colors.red,
          ),
        );
        notifyListeners();
      }
    } on Exception catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }

  /* this line of the end verification view */

  ContactModel _contactModel = ContactModel();
  ErrorContactModel _errorContactModel = ErrorContactModel();

  Future<void> fetchSaveContact(BuildContext context) async {
    try {
      String token = Constant.ACCESS_TOKEN;
      Uri url = Uri.parse(Constant.BASE_URL + '/customer/register/mandatory');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'AccessToken': token,
        },
        body: jsonEncode({
          "user_id": userC.text,
          "first_name": firstNameC.text,
          "last_name": lastNameC.text,
          "password": passwordC.text,
        }),
      );
      log('Response Body ${response.body}');
      var responseBody = jsonDecode(response.body);
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          responseBody['action'] == true) {
        _contactModel = ContactModel.fromJson(jsonDecode(response.body));
        Navigator.pushReplacementNamed(context, AppRoute.login);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_contactModel.message!),
            backgroundColor: Colors.green,
          ),
        );
        notifyListeners();
        clearTextField();
      } else {
        _errorContactModel = ErrorContactModel.fromJson(
          jsonDecode(response.body),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorContactModel.message!),
            backgroundColor: Colors.red,
          ),
        );
        notifyListeners();
      }
    } on Exception catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }
}
