class ProductModel {
  List<Data>? data;

  ProductModel({this.data});

  // ProductModel.fromJson(Map<String, dynamic> json) {
  //    if (json['data'] != null) {
  //     data = <Data>[];
  //     json['data'].forEach((v) {
  //       data!.add(Data.fromJson(v));
  //     });
  //   }
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   if (this.data != null) {
  //     data['data'] = this.data!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }

  ProductModel.fromJson(List<dynamic> json) {
    data = json.map((v) => Data.fromJson(v)).toList();
  }

  List<dynamic> toJson() {
    return this.data!.map((v) => v.toJson()).toList();
  }
}

class Data {
  int? id;
  String? name;
  int? qty;
  String? image_url;
  int? created_by;
  int? updated_by;
  int? category_id;
  String? createdAt;
  String? updatedAt;
  Category? category;
  User? createdBy;
  User? updatedBy;

  Data({this.id, this.name, this.qty, this.image_url, this.created_by, this.updated_by, this.category_id, this.createdAt, this.updatedAt, this.category, this.createdBy, this.updatedBy});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    qty = json['qty'];
    image_url = json['image_url'];
    created_by = json['created_by'];
    updated_by = json['updated_by'];
    category_id = json['category_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    category = Category.fromJson(json['category']);
    createdBy = User.fromJson(json['createdBy']);
    updatedBy = User.fromJson(json['updatedBy']);
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
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['category'] = this.category?.toJson();
    data['createdBy'] = this.createdBy?.toJson();
    data['updatedBy'] = this.updatedBy?.toJson();
  
    return data;
  }
}

class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
  
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? image;

  User({this.id, this.username, this.image});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['username'] = this.username;
    data['image'] = this.image;
  
    return data;
  }
}