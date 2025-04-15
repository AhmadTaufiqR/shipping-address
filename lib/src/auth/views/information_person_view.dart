import 'package:flutter/material.dart';
import 'package:shipping_address/common/widgets/custom_button.dart';
import 'package:shipping_address/common/widgets/custom_textfield.dart';

class InformationPersonView extends StatelessWidget {
  InformationPersonView({super.key});
  final _formKey = GlobalKey<FormState>();

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
              Text(
                'Informasi Kontak',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(height: 15),
              Text(
                'Silahkan masukkan informasi anda',
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
                      hintText: 'Nama Depan',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama depan wajib diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    CustomTextField.normalTextField(
                      hintText: 'Nama Belakang',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama belakang wajib diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 35),
                    CustomButton.normalCustomButton(
                      text: 'Simpan',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Berhasil menambahkan user'),
                              backgroundColor: Colors.green,
                            ),
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
