///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class SubDistrictModelData {
  /*
{
  "address": "Gayo Lues, Pining (Pinding)",
  "province": "NAD",
  "district": "Gayo Lues",
  "sub_district": "Pining (Pinding)",
  "sub_district_code": "TNCBTJ21702",
  "province_id": 21,
  "district_id": 264,
  "sub_district_id": 3373
} 
*/

  String? address;
  String? province;
  String? district;
  String? subDistrict;
  String? subDistrictCode;
  int? provinceId;
  int? districtId;
  int? subDistrictId;

  SubDistrictModelData({
    this.address,
    this.province,
    this.district,
    this.subDistrict,
    this.subDistrictCode,
    this.provinceId,
    this.districtId,
    this.subDistrictId,
  });
  SubDistrictModelData.fromJson(Map<String, dynamic> json) {
    address = json['address']?.toString();
    province = json['province']?.toString();
    district = json['district']?.toString();
    subDistrict = json['sub_district']?.toString();
    subDistrictCode = json['sub_district_code']?.toString();
    provinceId = json['province_id']?.toInt();
    districtId = json['district_id']?.toInt();
    subDistrictId = json['sub_district_id']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['address'] = address;
    data['province'] = province;
    data['district'] = district;
    data['sub_district'] = subDistrict;
    data['sub_district_code'] = subDistrictCode;
    data['province_id'] = provinceId;
    data['district_id'] = districtId;
    data['sub_district_id'] = subDistrictId;
    return data;
  }
}

class SubDistrictModel {
  /*
{
  "action": true,
  "message": "Data ditemukan",
  "data": [
    {
      "address": "Gayo Lues, Pining (Pinding)",
      "province": "NAD",
      "district": "Gayo Lues",
      "sub_district": "Pining (Pinding)",
      "sub_district_code": "TNCBTJ21702",
      "province_id": 21,
      "district_id": 264,
      "sub_district_id": 3373
    }
  ]
} 
*/

  bool? action;
  String? message;
  List<SubDistrictModelData?>? data;

  SubDistrictModel({this.action, this.message, this.data});
  SubDistrictModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    message = json['message']?.toString();
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <SubDistrictModelData>[];
      v.forEach((v) {
        arr0.add(SubDistrictModelData.fromJson(v));
      });
      this.data = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['action'] = action;
    data['message'] = message;
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['data'] = arr0;
    }
    return data;
  }
}
