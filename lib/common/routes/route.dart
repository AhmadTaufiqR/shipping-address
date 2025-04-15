// part of "../../main.dart";

import 'package:flutter/material.dart';
import 'package:shipping_address/src/auth/views/information_person_view.dart';
import 'package:shipping_address/src/auth/views/login_view.dart';
import 'package:shipping_address/src/auth/views/register_view.dart';
import 'package:shipping_address/src/auth/views/success_verification_view.dart';
import 'package:shipping_address/src/auth/views/verification_view.dart';

class AppRoute {
  static const String login = '/';
  static const String register = '/register';
  static const String verification = '/verification';
  static const String successVerification = '/success-verification';
  static const String informationContact = '/information-contact';

  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    login: (context) => LoginView(),
    register: (context) => RegisterView(),
    verification: (context) => VerificationView(),
    successVerification: (context) => SuccessVerificationView(),
    informationContact: (context) => InformationPersonView(),
  };
}
