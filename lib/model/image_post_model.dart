class ImagePostModel {
  String? image;
  String? description;

  ImagePostModel({required this.image, this.description});

  ImagePostModel.fromJson(Map<String, dynamic> json) {
    image = json["image"];
    description = json["description"];
  }

  Map<String, dynamic> tojson() {
    return {
      "image": image,
      "description": description,
    }; 
  }
}
