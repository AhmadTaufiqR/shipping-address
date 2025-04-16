import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shipping_address/common/widgets/custom_button.dart';
import 'package:shipping_address/common/widgets/custom_text_button.dart';
import 'package:shipping_address/common/widgets/custom_textfield.dart';
import 'package:shipping_address/main.dart';
import 'package:shipping_address/src/auth/providers/auth_provider.dart';

class VerificationView extends StatelessWidget {
  VerificationView({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(''), backgroundColor: Colors.white),
      body: WillPopScope(
        onWillPop: () async {
          authProvider.clearTextField();
          return true;
        },
        child: Center(
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
                  Consumer<AuthProvider>(
                    builder: (context, authP, _) {
                      return Text(
                        // TODO: ini kirim ke diambil dari controller yang ada di dalam provider.
                        'Masukkan kode verifikasi yang telah kami kirim ke ${authP.userC.text}',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  SizedBox(height: 25),
                  Consumer<AuthProvider>(
                    builder: (context, authP, _) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField.normalTextField(
                              hintText: 'Kode Verifikasi',
                              controller: authP.codeC,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  Provider.of<LoadingProvider>(
                                    context,
                                    listen: false,
                                  ).show();
                                  await authP.fetchVerification(context).then((
                                    value,
                                  ) {
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
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
