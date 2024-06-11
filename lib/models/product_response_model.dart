class ProductResponseModel {
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
  CreatedBy? createdByUser;
  CreatedBy? updatedByUser;

  ProductResponseModel(
      {this.id,
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
      this.updatedByUser});

  ProductResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    qty = json['qty'];
    imageUrl = json['image_url'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    categoryId = json['category_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    createdByUser = json['createdByUser'] != null
        ? new CreatedBy.fromJson(json['createdByUser'])
        : null;
    updatedByUser = json['updatedByUser'] != null
        ? new CreatedBy.fromJson(json['updatedByUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['qty'] = this.qty;
    data['image_url'] = this.imageUrl;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['category_id'] = this.categoryId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.createdByUser != null) {
      data['createdByUser'] = this.createdByUser!.toJson();
    }
    if (this.createdByUser != null) {
      data['createdByUser'] = this.createdByUser!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class CreatedBy {
  int? id;
  String? username;
  String? image;

  CreatedBy({this.id, this.username, this.image});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['image'] = this.image;
    return data;
  }
}
