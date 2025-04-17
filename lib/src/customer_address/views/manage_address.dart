// ignore_for_file: collection_methods_unrelated_type, prefer_typing_uninitialized_variables, must_be_immutable, use_build_context_synchronously

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shipping_address/common/routes/route.dart';
import 'package:shipping_address/common/widgets/custom_button.dart';
import 'package:shipping_address/common/widgets/custom_textfield.dart';
import 'package:shipping_address/main.dart';
import 'package:shipping_address/src/customer_address/models/district_model.dart';
import 'package:shipping_address/src/customer_address/models/province_model.dart';
import 'package:shipping_address/src/customer_address/models/sub_district_model.dart';
import 'package:shipping_address/src/customer_address/providers/customer_provider.dart';

class ManageAddress extends StatefulWidget {
  final bool isEdit;
  final int? index;
  const ManageAddress({super.key, this.isEdit = false, this.index});

  @override
  State<ManageAddress> createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  final _formKey = GlobalKey<FormState>();

  var selectedValue;

  @override
  void initState() {
    if (widget.isEdit == true) {
      Provider.of<CustomerProvider>(
        context,
        listen: false,
      ).getDataEdit(widget.index!);
    }
    Provider.of<CustomerProvider>(context, listen: false).fetchProvince();
    super.initState();
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
      body: WillPopScope(
        onWillPop: () async {
          var customerP = Provider.of<CustomerProvider>(context, listen: false);
          customerP.clearTextField();
          return true;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Consumer<CustomerProvider>(
              builder: (context, customerP, _) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField.normalTextField(
                        labelText: 'Label Alamat',
                        controller: customerP.addressLabelC,
                        hintText: 'Label Alamat',
                      ),
                      SizedBox(height: 12),
                      CustomTextField.normalTextField(
                        labelText: 'Nama Penerima',
                        required: true,
                        controller: customerP.nameC,
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
                        controller: customerP.numberC,
                        hintText: 'Nomor Telepon',
                        maxLength: 13,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                      SizedBox(height: 12),
                      CustomTextField.normalTextField(
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        controller: customerP.emailC,
                        hintText: 'Email',
                        validator: (value) {
                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(value!)) {
                            return 'Format email tidak valid';
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
                                'Provinsi',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
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
                          // Dropdown untuk Provinsi
                          SearchField<ProvinceModelData>(
                            controller: customerP.provinceC,
                            enabled: true,
                            searchInputDecoration: SearchInputDecoration(
                              searchStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 1, // Border normal
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  width: 1, // Border normal
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  width: 1, // Border normal
                                  color: Colors.red,
                                ),
                              ),
                              hintText: 'Provinsi',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 1, // Border normal
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            onSuggestionTap: (value) {
                              String? selectedCode = value.item!.code;
                              customerP.fetchDistrict(selectedCode!);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Provinsi wajib diisi';
                              }
                              return null;
                            },
                            emptyWidget: Container(
                              decoration: BoxDecoration(border: Border.all()),
                              height: 200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            selectedValue: selectedValue,
                            suggestionsDecoration: SuggestionDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suggestions:
                                customerP.provinceModel.data
                                    ?.map(
                                      (e) => SearchFieldListItem<
                                        ProvinceModelData
                                      >(e?.name ?? '-', item: e),
                                    )
                                    .toList() ??
                                [],
                          ),
                        ],
                      ),

                      SizedBox(height: 12),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Kota / Kabupaten',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
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
                          // Dropdown untuk Provinsi
                          SearchField<DistrictModelData>(
                            controller: customerP.districtC,
                            enabled: true,
                            searchInputDecoration: SearchInputDecoration(
                              searchStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 1, // Border normal
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  width: 1, // Border normal
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  width: 1, // Border normal
                                  color: Colors.red,
                                ),
                              ),
                              hintText: 'Kota / Kabupaten',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 1, // Border normal
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            onSuggestionTap: (value) {
                              customerP.fetchSubDistrict(
                                customerP.extractName(value.item?.name ?? '-'),
                              );
                            },
                            emptyWidget: Container(
                              decoration: BoxDecoration(border: Border.all()),
                              height: 200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            selectedValue: selectedValue,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kota / Kabupaten wajib diisi';
                              }
                              return null;
                            },
                            suggestionsDecoration: SuggestionDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suggestions:
                                customerP.districtModel.data
                                    ?.map(
                                      (e) => SearchFieldListItem<
                                        DistrictModelData
                                      >(e?.name ?? '-', item: e),
                                    )
                                    .toList() ??
                                [],
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Kecamatan',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
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
                          // Dropdown untuk Provinsi
                          SearchField<SubDistrictModelData>(
                            controller: customerP.subDistictC,
                            enabled: true,
                            searchInputDecoration: SearchInputDecoration(
                              searchStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 1, // Border normal
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  width: 1, // Border normal
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  width: 1, // Border normal
                                  color: Colors.red,
                                ),
                              ),
                              hintText: 'Kecamatan',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 1, // Border normal
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            onSuggestionTap: (value) {
                              customerP.provinceId = value.item?.provinceId;
                              customerP.districtId = value.item?.districtId;
                              customerP.subDistrictId =
                                  value.item?.subDistrictId;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kecamatan wajib diisi';
                              }
                              return null;
                            },
                            emptyWidget: Container(
                              decoration: BoxDecoration(border: Border.all()),
                              height: 200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            selectedValue: selectedValue,
                            suggestionsDecoration: SuggestionDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suggestions:
                                customerP.subDistrictModel.data
                                    ?.map(
                                      (e) => SearchFieldListItem<
                                        SubDistrictModelData
                                      >(e?.subDistrict ?? '-', item: e),
                                    )
                                    .toList() ??
                                [],
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      CustomTextField.normalTextField(
                        labelText: 'Kode Pos',
                        required: true,
                        controller: customerP.postalCodeC,
                        keyboardType: TextInputType.numberWithOptions(),
                        hintText: 'Kode Pos',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kode Pos wajib diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      FormField<String>(
                        validator: (value) {
                          if (customerP.selectedLocation == null) {
                            return 'Lokasi belum dipilih';
                          }
                          return null;
                        },
                        builder: (FormFieldState<String> state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Pin Alamat',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
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
                                  onTap: () async {
                                    await Navigator.pushNamed(
                                      context,
                                      AppRoute.mapsAddress,
                                    );
                                  },
                                  child: Container(
                                    height: 57,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        width: 1,
                                        color:
                                            state.hasError
                                                ? Colors.red
                                                : Colors.grey.shade400,
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
                                              customerP.selectedLocation ??
                                                  'Pilih lokasi di peta terlebih dahulu',
                                              style: TextStyle(
                                                color:
                                                    customerP.selectedLocation !=
                                                            null
                                                        ? Colors.blue
                                                        : Colors.grey,
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
                              if (state.hasError)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    left: 12,
                                  ),
                                  child: Text(
                                    state.errorText!,
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        206,
                                        54,
                                        43,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: 12),
                      CustomTextField.normalTextField(
                        labelText: 'NPWP',
                        controller: customerP.npwpC,
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
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
                                customerP.pickerFile(context);
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                            customerP.uploadModel.fileUrl ??
                                                '.jpg, .png, .pdf',
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
                      CustomButton.normalCustomButton(
                        text: widget.isEdit ? 'Edit' : 'Simpan',
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            Provider.of<LoadingProvider>(
                              context,
                              listen: false,
                            ).show();

                            if (widget.isEdit) {
                              await customerP
                                  .fetchUpdateAddress(context, widget.index!)
                                  .then((value) {
                                    Provider.of<LoadingProvider>(
                                      context,
                                      listen: false,
                                    ).hide();
                                  });
                            } else {
                              await customerP.fetchAddAddress(context).then((
                                value,
                              ) {
                                Provider.of<LoadingProvider>(
                                  context,
                                  listen: false,
                                ).hide();
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
