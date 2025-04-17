///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class DistrictModelMeta {
  /*
{
  "administrative_area_level": 2,
  "updated_at": "2024-10-09T16:58:25+00:00"
} 
*/

  int? administrativeAreaLevel;
  String? updatedAt;

  DistrictModelMeta({this.administrativeAreaLevel, this.updatedAt});
  DistrictModelMeta.fromJson(Map<String, dynamic> json) {
    administrativeAreaLevel = json['administrative_area_level']?.toInt();
    updatedAt = json['updated_at']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['administrative_area_level'] = administrativeAreaLevel;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class DistrictModelData {
  /*
{
  "code": "11.05",
  "name": "Kab. Aceh Barat"
} 
*/

  String? code;
  String? name;

  DistrictModelData({this.code, this.name});
  DistrictModelData.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toString();
    name = json['name']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    return data;
  }
}

class DistrictModel {
  /*
{
  "data": [
    {
      "code": "11.05",
      "name": "Kab. Aceh Barat"
    }
  ],
  "meta": {
    "administrative_area_level": 2,
    "updated_at": "2024-10-09T16:58:25+00:00"
  }
} 
*/

  List<DistrictModelData?>? data;
  DistrictModelMeta? meta;

  DistrictModel({this.data, this.meta});
  DistrictModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <DistrictModelData>[];
      v.forEach((v) {
        arr0.add(DistrictModelData.fromJson(v));
      });
      this.data = arr0;
    }
    meta =
        (json['meta'] != null)
            ? DistrictModelMeta.fromJson(json['meta'])
            : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['data'] = arr0;
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}
