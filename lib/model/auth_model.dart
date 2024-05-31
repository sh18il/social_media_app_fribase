class UserModel {
  String? username;
  String? email;
  String? uid;
  String? password;
  List? followers;
  List? following;

  UserModel({
    this.username,
    required this.email,
    this.uid,
    required this.password,
    this.followers,
    this.following,
  });

  UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    username = json["username"];
    email = json["email"];
    uid = json["uid"];
    password = json["password"];
    followers = json["followers"];
    following = json["following"];
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "uid": uid,
      "password": password,
      "followers": followers,
      "following": following,
    };
  }
}