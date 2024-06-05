class ImagePostModel {
  String? image;
  String? description;
  String? uid;
  bool? isLiked;
  String? username;
  String? userImage;

  ImagePostModel({
    this.image,
    this.description,
    this.uid,
    this.isLiked,
    this.username,
    this.userImage,
  });

  ImagePostModel.fromJson(Map<String, dynamic> json) {
    image = json["image"];
    description = json["description"];
    uid = json["uid"];
    isLiked = json["is_liked"];
    username = json["username"];
    userImage = json["userImage"];
  }

  Map<String, dynamic> tojson() {
    return {
      "image": image,
      "description": description,
      "uid": uid,
      "is_liked": isLiked,
      "username": username,
      "userImage": userImage,
    };
  }
}
