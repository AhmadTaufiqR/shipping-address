///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class DeleteAddressModel {
  /*
{
  "action": true
} 
*/

  bool? action;

  DeleteAddressModel({this.action});
  DeleteAddressModel.fromJson(Map<String, dynamic> json) {
    action = json['action'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['action'] = action;
    return data;
  }
}
