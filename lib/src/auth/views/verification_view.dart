import 'package:flutter/material.dart';
import 'package:shipping_address/common/routes/route.dart';
import 'package:shipping_address/common/widgets/custom_button.dart';
import 'package:shipping_address/common/widgets/custom_text_button.dart';
import 'package:shipping_address/common/widgets/custom_textfield.dart';

class VerificationView extends StatelessWidget {
  VerificationView({super.key});
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
              children: [
                Text(
                  'Verifikasi Kontak',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                SizedBox(height: 15),
                Text(
                  // TODO: ini kirim ke diambil dari controller yang ada di dalam provider.
                  'Masukkan kode verifikasi yang telah kami kirim ke',
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
                        hintText: 'Kode Verifikasi',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kode virifikasi wajib diisi';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 35),
                      CustomButton.normalCustomButton(
                        text: 'Masukkan Kode',
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
                              AppRoute.successVerification,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 35),
                      Text(
                        'Tidak menerima kode verifikasi?',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      CustomTextButton.normalCustomTextButton(
                        text: 'Kirim Ulang',
                        onTap: () {
                          // Navigator.pushNamed(context, AppRoute.register);
                        },
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
