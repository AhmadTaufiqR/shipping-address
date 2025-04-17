// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipping_address/common/helper/constant.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shipping_address/common/routes/route.dart';
import 'package:shipping_address/src/customer_address/models/add_address_model.dart';
import 'package:shipping_address/src/customer_address/models/delete_address_model.dart';
import 'package:shipping_address/src/customer_address/models/district_model.dart';
import 'package:shipping_address/src/customer_address/models/edit_address_model.dart';
import 'package:shipping_address/src/customer_address/models/list_address_model.dart';
import 'package:shipping_address/src/customer_address/models/province_model.dart';
import 'package:shipping_address/src/customer_address/models/sub_district_model.dart';
import 'package:shipping_address/src/customer_address/models/upload_model.dart';

class CustomerProvider extends ChangeNotifier {
  Future<void> fetchLogout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Uri url = Uri.parse(Constant.BASE_URL + '/customer/logout');
      var token = prefs.getString(Constant.kPrefToken);
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
      );
      Navigator.pushReplacementNamed(context, AppRoute.login);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil Logout'),
          backgroundColor: Colors.green,
        ),
      );
      await prefs.remove(Constant.kPrefToken);
      notifyListeners();
    } on Exception catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }

  var _selectedLocation;
  get selectedLocation => _selectedLocation;

  void setSelectedLocation(String selectionLocation) {
    _selectedLocation = selectionLocation;
    notifyListeners();
  }

  ProvinceModel _provinceModel = ProvinceModel();
  ProvinceModel get provinceModel => _provinceModel;
  DistrictModel _districtModel = DistrictModel();
  DistrictModel get districtModel => _districtModel;
  SubDistrictModel _subDistrictModel = SubDistrictModel();
  SubDistrictModel get subDistrictModel => _subDistrictModel;

  Future<void> fetchProvince() async {
    try {
      Uri url = Uri.parse(Constant.BASE_URL_REGION + '/provinces.json');
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      _provinceModel = ProvinceModel.fromJson(jsonDecode(response.body));
      notifyListeners();
    } catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }

  Future<void> fetchDistrict(String id) async {
    try {
      Uri url = Uri.parse(Constant.BASE_URL_REGION + '/regencies/$id.json');
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      _districtModel = DistrictModel.fromJson(jsonDecode(response.body));
      log(response.body);
      notifyListeners();
    } catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }

  Future<void> fetchSubDistrict(String name) async {
    try {
      Uri url = Uri.parse(
        Constant.BASE_URL + '/address/subdistricts/search',
      ).replace(queryParameters: {'q': name});
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      _subDistrictModel = SubDistrictModel.fromJson(jsonDecode(response.body));
      log(response.body);
      notifyListeners();
    } catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }

  UploadModel _uploadModel = UploadModel();
  UploadModel get uploadModel => _uploadModel;

  Future<UploadModel?> fetchUploadFile(String filePath) async {
    try {
      Uri url = Uri.parse('${Constant.BASE_URL}/file/upload');
      File file = File(filePath);
      String fileName = path.basename(file.path);
      var request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath(
          'file_data',
          file.path,
          filename: fileName,
        ),
      );
      var response = await request.send();
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          jsonResponse['action'] == true) {
        _uploadModel = UploadModel.fromJson(jsonResponse);
        notifyListeners();
        return _uploadModel;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<void> pickerFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final file = result.files.first;
        final uploadResponse = await fetchUploadFile(file.path ?? '');
        if (uploadResponse != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload berhasil: ${uploadResponse.message}'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload gagal. Silakan coba lagi.')),
          );
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Tidak ada file yang dipilih')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  String extractName(String name) {
    return name.replaceFirst(RegExp(r'^Kab\.\s*'), '');
  }

  AddAddressModel _addAddressModel = AddAddressModel();
  TextEditingController addressLabelC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController numberC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController postalCodeC = TextEditingController();
  TextEditingController npwpC = TextEditingController();
  TextEditingController provinceC = TextEditingController();
  TextEditingController districtC = TextEditingController();
  TextEditingController subDistictC = TextEditingController();
  int? provinceId;
  int? districtId;
  int? subDistrictId;
  double? lat;
  double? long;

  clearTextField() {
    addressLabelC.clear();
    nameC.clear();
    numberC.clear();
    emailC.clear();
    postalCodeC.clear();
    npwpC.clear();
    provinceC.clear();
    districtC.clear();
    subDistictC.clear();
    _uploadModel = UploadModel();
    _selectedLocation = null;
    notifyListeners();
  }

  Future<void> fetchAddAddress(BuildContext context) async {
    try {
      var pref = await SharedPreferences.getInstance();
      var token = pref.getString(Constant.kPrefToken);
      Uri url = Uri.parse(Constant.BASE_URL + '/customer/address');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({
          "address": selectedLocation,
          "address_label": addressLabelC.text,
          "name": nameC.text,
          "phone_number": numberC.text,
          "email": emailC.text,
          "province_id": provinceId,
          "district_id": districtId,
          "sub_district_id": subDistrictId,
          "postal_code": postalCodeC.text,
          "lat": lat,
          "long": long,
          "address_map": selectedLocation,
          "npwp": npwpC.text,
          "npwp_file": _uploadModel.fileUrl,
        }),
      );
      var responseBody = jsonDecode(response.body);
      log(response.body);
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          responseBody['action'] == true) {
        _addAddressModel = AddAddressModel.fromJson(jsonDecode(response.body));
        loadAddressList();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_addAddressModel.message!),
            backgroundColor: Colors.green,
          ),
        );
        clearTextField();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi Kesalahan'),
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

  List<ListAddressModel> _listAddressModel = [];
  ListAddressModel _addressModel = ListAddressModel();
  List<ListAddressModel> get listAddressModel => _listAddressModel;
  ListAddressModel get addressModel => _addressModel;
  int? _primaryAddressId;
  int? get primaryAddressId => _primaryAddressId;

  Future<List<ListAddressModel>> fetchListAddress() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(Constant.kPrefToken);
      Uri url = Uri.parse(Constant.BASE_URL + '/customer/address');
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
      );
      log(response.body);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        List<ListAddressModel> addresses =
            jsonResponse
                .map((item) => ListAddressModel.fromJson(item))
                .toList();
        _listAddressModel = addresses;
        notifyListeners();

        return addresses;
      } else {
        throw Exception('Gagal mengambil data alamat: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
      notifyListeners();
      return [];
    }
  }

  void makeAddressPrimary(int index) async {
    if (index >= 0 && index < _listAddressModel.length) {
      var selectedAddress = _listAddressModel[index];
      _listAddressModel.removeAt(index);
      _listAddressModel.insert(0, selectedAddress);
      _primaryAddressId = selectedAddress.addressId;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(Constant.kPrefPrimary, selectedAddress.addressId!);
      notifyListeners();
    }
  }

  Future<void> loadAddressList() async {
    final prefs = await SharedPreferences.getInstance();
    _primaryAddressId = prefs.getInt(Constant.kPrefPrimary);
    notifyListeners();

    _listAddressModel = await fetchListAddress();

    _listAddressModel.sort((a, b) {
      if (a.addressId == _primaryAddressId) return -1;
      if (b.addressId == _primaryAddressId) return 1;
      return 0;
    });

    notifyListeners();
  }

  Future<ListAddressModel?> getDataEdit(int id) async {
    try {
      _addressModel = _listAddressModel.firstWhere(
        (element) => element.addressId == id,
        orElse: () => ListAddressModel(),
      );

      addressLabelC.text = _addressModel.addressLabel ?? '-';
      nameC.text = _addressModel.name ?? '-';
      numberC.text = _addressModel.phoneNumber ?? '-';
      emailC.text = _addressModel.email ?? '-';
      postalCodeC.text = _addressModel.postalCode ?? '-';
      npwpC.text = _addressModel.npwp ?? '-';
      _uploadModel = UploadModel(fileUrl: _addressModel.npwpFile ?? '-');
      _selectedLocation = _addressModel.addressMap ?? '-';
      provinceC.text = _addressModel.provinceName ?? '-';
      districtC.text = _addressModel.districtName ?? '-';
      subDistictC.text = _addressModel.subDistrictName ?? '-';
      lat = _addressModel.lat;
      long = _addressModel.long;

      notifyListeners();

      return _addressModel;
    } catch (e) {
      log('Error getDataEdit: $e');
      return null;
    }
  }

  Future<void> fetchUpdateAddress(BuildContext context, int id) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(Constant.kPrefToken);
      Uri url = Uri.parse(Constant.BASE_URL + '/customer/address/$id');
      EditAddressModel editAddress = EditAddressModel();
      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({
          "address": selectedLocation,
          "address_label": addressLabelC.text,
          "name": nameC.text,
          "phone_number": numberC.text,
          "email": emailC.text,
          "province_id": provinceId,
          "district_id": districtId,
          "sub_district_id": subDistrictId,
          "postal_code": postalCodeC.text,
          "lat": lat,
          "long": long,
          "address_map": selectedLocation,
          "npwp": npwpC.text,
          "npwp_file": _uploadModel.fileUrl,
        }),
      );

      log(response.body);
      if (response.statusCode == 200) {
        editAddress = EditAddressModel.fromJson(jsonDecode(response.body));
        loadAddressList();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(editAddress.message!),
            backgroundColor: Colors.green,
          ),
        );
        clearTextField();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(editAddress.message!),
            backgroundColor: Colors.red,
          ),
        );
        throw Exception('Gagal mengambil data alamat: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }

  Future<void> fetchDeleteAddress(BuildContext context, int id) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(Constant.kPrefToken);
      Uri url = Uri.parse(Constant.BASE_URL + '/customer/address/delete');
      DeleteAddressModel deleteAddressModel = DeleteAddressModel();
      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({"address_id": id}),
      );

      deleteAddressModel = DeleteAddressModel.fromJson(
        jsonDecode(response.body),
      );
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          deleteAddressModel.action == true) {
        loadAddressList();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil menghapus alamat'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus alamat'),
            backgroundColor: Colors.red,
          ),
        );
        throw Exception('Gagal mengambil data alamat: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
      notifyListeners();
    }
  }
}
