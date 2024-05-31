class ImagePostModel {
  String? image;
  String? description;
  String? uid;

  ImagePostModel({required this.image, this.description,required this.uid});

  ImagePostModel.fromJson(Map<String, dynamic> json) {
    image = json["image"];
    description = json["description"];
    uid = json["uid"];
  }

  Map<String, dynamic> tojson() {
    return {
      "image": image,
      "description": description,
      "uid": uid,
    };
  }
}
