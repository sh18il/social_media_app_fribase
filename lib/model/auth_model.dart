class UserModel {
  String? username;
  String? email;
  String? uid;

  String? image;
  int? followers;
  int? following;

  UserModel({
    this.username,
    this.email,
    this.uid,
    this.image,
    this.followers,
    this.following,
  });

  UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    username = json["username"];
    email = json["email"];
    uid = json["uid"];

    image = json["image"];
    followers = json["followers"];
    following = json["following"];
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "uid": uid,
      "image": image,
      "followers": followers,
      "following": following,
    };
  }
}
