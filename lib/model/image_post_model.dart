class ImagePostModel {
  String? image;
  String? description;
  String? uid;
  bool? isLiked;

  ImagePostModel({this.image, this.description, this.uid, this.isLiked});

  ImagePostModel.fromJson(Map<String, dynamic> json) {
    image = json["image"];
    description = json["description"];
    uid = json["uid"];
    isLiked = json["is_liked"];
  }

  Map<String, dynamic> tojson() {
    return {
      "image": image,
      "description": description,
      "uid": uid,
      "is_liked": isLiked,
    };
  }
}
