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
  int? qty;
  String? imageUrl;
  int? createdBy;
  int? updatedBy;
  int? categoryId;
  String? createdAt;
  String? updatedAt;
  Category? category;
  User? createdByUser;
  User? updatedByUser;

  DataResponse({
    this.id, 
    this.name, 
    this.qty, 
    this.imageUrl, 
    this.createdBy, 
    this.updatedBy, 
    this.categoryId, 
    this.createdAt, 
    this.updatedAt, 
    this.category, 
    this.createdByUser, 
    this.updatedByUser
  });

  DataResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    qty = json['qty'];
    imageUrl = json['image_url'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    categoryId = json['category_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    createdByUser = json['createdBy'] != null ? User.fromJson(json['createdBy']) : null;
    updatedByUser = json['updatedBy'] != null ? User.fromJson(json['updatedBy']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['qty'] = qty;
    data['image_url'] = imageUrl;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['category_id'] = categoryId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.createdByUser != null) {
      data['createdBy'] = this.createdByUser!.toJson();
    }
    if (this.updatedByUser != null) {
      data['updatedBy'] = this.updatedByUser!.toJson();
    }
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
    data['id'] = id;
    data['name'] = name;
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
    data['id'] = id;
    data['username'] = username;
    data['image'] = image;
    return data;
  }
}