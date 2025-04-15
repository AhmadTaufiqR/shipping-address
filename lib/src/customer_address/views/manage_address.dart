import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shipping_address/common/routes/route.dart';
import 'package:shipping_address/common/widgets/custom_button.dart';
import 'package:shipping_address/common/widgets/custom_textarea.dart';
import 'package:shipping_address/common/widgets/custom_textfield.dart';

class ManageAddress extends StatefulWidget {
  const ManageAddress({super.key});

  @override
  State<ManageAddress> createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  final _formKey = GlobalKey<FormState>();

  String? _nameFile;

  picker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = result.files.first;
      // print(file.name);
      setState(() {
        _nameFile = file.name;
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 45,
        title: Text(
          'Alamat Pengiriman',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        actionsPadding: EdgeInsets.symmetric(horizontal: 5),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField.normalTextField(
                  labelText: 'Label Alamat',
                  required: true,
                  hintText: 'Label Alamat',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Label Alamat wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                CustomTextField.normalTextField(
                  labelText: 'Nama Penerima',
                  required: true,
                  hintText: 'Nama Penerima',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Penerima wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                CustomTextField.normalTextField(
                  labelText: 'Nomor Telepon',
                  required: true,
                  hintText: 'Nomor Telepon',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor Telepon wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                CustomTextField.normalTextField(
                  labelText: 'Email',
                  hintText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                CustomTextField.normalTextField(
                  labelText: 'Kota atau Kecamatan',
                  hintText: 'Kota atau Kecamatan',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kota atau kecamatan wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                CustomTextField.normalTextField(
                  labelText: 'Kode Pos',
                  required: true,
                  hintText: 'Kode Pos',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Label Alamat wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                CustomTextarea.normalTextArea(
                  labelText: 'Alamat Lengkap',
                  required: true,
                  hintText: 'Nama Jalan, Nomor rumah, Nomor Komplek',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Label Alamat wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Pin Alamat',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '*',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Material(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.pushNamed(context, AppRoute.mapsAddress);
                        },
                        child: Container(
                          height: 57,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1, // Border normal
                              color: Colors.grey.shade400,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 25,
                                color: Colors.blue,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    'Mangga Besar, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta Daerah Khusus Ibukota Jakarta Daerah Khusus Ibukota Jakarta',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                CustomTextField.normalTextField(
                  labelText: 'NPWP',
                  icRequired: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.info_outline, // Ikone informasi
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  hintText: 'Nomor NPWP',
                ),
                SizedBox(height: 12),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Unggah File',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.info_outline, // Ikone informasi
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Material(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          picker();
                        },
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(12),
                          dashPattern: [6, 3],
                          color: Colors.grey,
                          strokeWidth: 1.2,
                          child: Container(
                            height: 120,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.upload,
                                    size: 25,
                                    color: Colors.blue,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      _nameFile ?? '.jpg, .png, .pdf',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                CustomButton.normalCustomButton(text: 'Simpan', onTap: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
