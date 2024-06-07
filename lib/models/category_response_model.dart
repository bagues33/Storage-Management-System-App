class CategoryResponseModel {
  DataResponse? data;

  CategoryResponseModel({this.data});

  CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? DataResponse.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataResponse {
  int? id;
  String? name;

  DataResponse({this.id, this.name});

  DataResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    
    return data;
  }
}