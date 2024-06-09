class CategoryModel {
  List<Data>? data;

  CategoryModel({this.data});

  CategoryModel.fromJson(List<dynamic> json) {
    data = json.map((item) => Data.fromJson(item)).toList();
  }

  List<dynamic> toJson() {
    return this.data!.map((v) => v.toJson()).toList();
  }
}

class Data {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Data({this.id, this.name, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
    };
  }
}