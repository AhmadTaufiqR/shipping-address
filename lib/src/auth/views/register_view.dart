import 'package:flutter/material.dart';
import 'package:shipping_address/common/routes/route.dart';
import 'package:shipping_address/common/widgets/custom_button.dart';
import 'package:shipping_address/common/widgets/custom_text_button.dart';
import 'package:shipping_address/common/widgets/custom_textfield.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(''), backgroundColor: Colors.white),
      body: Center(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Pendaftaran',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 15),
                Text(
                  'Silahkan isi data dengan benar untuk membuat akun Blueray Cargo',
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
                        hintText: 'Email atau nomor telpon',
                        autovalidateMode: AutovalidateMode.onUnfocus,
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

                      SizedBox(height: 35),
                      CustomButton.normalCustomButton(
                        text: 'Daftar Sekarang',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text('Berhasil menambahkan user'),
                            //     backgroundColor: Colors.green,
                            //   ),
                            // );
                            Navigator.pushNamed(context, AppRoute.verification);
                          }
                        },
                      ),
                      SizedBox(height: 35),
                      Text(
                        'Dengan mendaftar anda telah menyetujui',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextButton.normalCustomTextButton(
                            text: 'Syarat & ketentuan',
                            onTap: () {
                              // Navigator.pushNamed(context, AppRoute.register);
                            },
                          ),
                          Text(
                            ' dan ',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          CustomTextButton.normalCustomTextButton(
                            text: 'Kebijakan Privasi',
                            onTap: () {
                              // Navigator.pushNamed(context, AppRoute.register);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
