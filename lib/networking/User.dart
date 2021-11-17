class User {
  String email;
  String username;

  User(this.username, this.email);

  User.fromJson(Map<String, dynamic> json)
      : email = json["email"],
        username = json["username"];

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "username": username
    };
  }
}
