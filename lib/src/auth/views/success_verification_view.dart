import 'package:flutter/material.dart';
import 'package:shipping_address/common/routes/route.dart';
import 'package:shipping_address/common/widgets/custom_button.dart';
import 'package:shipping_address/common/widgets/custom_textfield.dart';
import 'package:shipping_address/generated/assets.dart';

class SuccessVerificationView extends StatefulWidget {
  const SuccessVerificationView({super.key});

  @override
  State<SuccessVerificationView> createState() =>
      _SuccessVerificationViewState();
}

class _SuccessVerificationViewState extends State<SuccessVerificationView> {
  final _formKey = GlobalKey<FormState>();

  bool _obsecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(''), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(Assets.assetsIconsIcCheck, scale: 5),
              Text(
                'Verifikasi Kontak',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(height: 15),
              Text(
                'Email Anda berhasil terverifikasi. Sekarang Anda bisa login dengan email',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              Text(
                'Silahkan masukkan password yang kamu inginkan',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField.normalTextField(
                      hintText: 'Password',
                      obscureText: _obsecure,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password wajib diisi';
                        }
                        if (value.length < 8) {
                          return 'Password minimal 8 karakter';
                        }
                        final passwordRegex = RegExp(
                          r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
                        );
                        if (!passwordRegex.hasMatch(value)) {
                          return 'Password harus '
                              'mengandung huruf besar, \nangka, dan simbol';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 35),
                    CustomButton.normalCustomButton(
                      text: 'Selanjutnya',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Berhasil menambahkan user'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pushNamed(
                            context,
                            AppRoute.informationContact,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
