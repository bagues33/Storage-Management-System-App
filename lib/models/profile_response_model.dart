class ProfileResponseModel {
  int? id;
  String? username;
  String? password;
  String? image;
  String? createdAt;
  String? updatedAt;

  ProfileResponseModel(
      {this.id,
      this.username,
      this.password,
      this.image,
      this.createdAt,
      this.updatedAt});

  ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    image = json['image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['image'] = this.image;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
