class ProductResponseModel {
  DataResponse? data;

  ProductResponseModel({this.data});

  ProductResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? qty;
  String? image_url;
  int? created_by;
  int? updated_by;
  int? category_id;

  DataResponse({this.id, this.name, this.qty, this.image_url, this.created_by, this.updated_by, this.category_id});

  DataResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    qty = json['qty'];
    image_url = json['image_url'];
    created_by = json['created_by'];
    updated_by = json['updated_by'];
    category_id = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['qty'] = qty;
    data['image_url'] = image_url;
    data['created_by'] = created_by;
    data['updated_by'] = updated_by;
    data['category_id'] = category_id;
    return data;
  }
}