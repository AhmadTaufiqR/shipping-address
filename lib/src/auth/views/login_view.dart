import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shipping_address/common/routes/route.dart';
import 'package:shipping_address/common/widgets/custom_button.dart';
import 'package:shipping_address/common/widgets/custom_text_button.dart';
import 'package:shipping_address/common/widgets/custom_textfield.dart';
import 'package:shipping_address/generated/assets.dart';
import 'package:shipping_address/main.dart';
import 'package:shipping_address/src/auth/providers/auth_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  bool _obsecure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            margin: EdgeInsets.only(top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 15),
                Text(
                  'Silahkan masuk untuk dapat menggunakan semua fitur aplikasi Blueray Cargo',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25),
                Consumer<AuthProvider>(
                  builder: (context, authP, _) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField.normalTextField(
                            hintText: 'Email atau nomor telpon',
                            autovalidateMode: AutovalidateMode.onUnfocus,
                            controller: authP.userC,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email wajib diisi';
                              }
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          CustomTextField.normalTextField(
                            hintText: 'Password',
                            obscureText: _obsecure,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: authP.passwordC,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obsecure = !_obsecure;
                                });
                              },
                              child: Icon(
                                _obsecure
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                size: 20,
                              ),
                            ),
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Password wajib diisi';
                            //   }
                            //   if (value.length < 8) {
                            //     return 'Password minimal 8 karakter';
                            //   }
                            //   final passwordRegex = RegExp(
                            //     r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
                            //   );
                            //   if (!passwordRegex.hasMatch(value)) {
                            //     return 'Password harus '
                            //         'mengandung huruf besar, \nangka, dan simbol';
                            //   }
                            //   return null;
                            // },
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CustomTextButton.normalCustomTextButton(
                                text: 'Lupa Password?',
                                onTap: () {},
                              ),
                            ],
                          ),
                          SizedBox(height: 35),
                          Text(
                            'atau masuk menggunakan\nmetode yang lain',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 15),
                          InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade500),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SvgPicture.asset(
                                Assets.assetsIconsIconsGoogle,
                                width: 30,
                              ),
                            ),
                          ),
                          SizedBox(height: 35),
                          CustomButton.normalCustomButton(
                            text: 'Login',
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                Provider.of<LoadingProvider>(
                                  context,
                                  listen: false,
                                ).show();

                                await authP.fetchLogin(context).then((value) {
                                  Provider.of<LoadingProvider>(
                                    context,
                                    listen: false,
                                  ).hide();
                                });
                              }
                            },
                          ),
                          SizedBox(height: 35),
                          Text(
                            'Tidak memiliki akun?',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5),
                          CustomTextButton.normalCustomTextButton(
                            text: 'Daftar Sekarang',
                            onTap: () {
                              authP.clearTextField();
                              Navigator.pushNamed(context, AppRoute.register);
                            },
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
