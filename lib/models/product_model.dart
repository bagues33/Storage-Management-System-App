class ProductModel {
  List<Data>? data;

  ProductModel({this.data});

  ProductModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? qty;
  String? image_url;
  int? created_by;
  int? updated_by;
  int? category_id;

  Data({this.id, this.name, this.qty, this.image_url, this.created_by, this.updated_by, this.category_id});

  Data.fromJson(Map<String, dynamic> json) {
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
    data['id'] = this.id;
    data['name'] = this.name;
    data['qty'] = this.qty;
    data['image_url'] = this.image_url;
    data['created_by'] = this.created_by;
    data['updated_by'] = this.updated_by;
    data['category_id'] = this.category_id;
  
    return data;
  }
}