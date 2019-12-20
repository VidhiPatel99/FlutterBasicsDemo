class User {
  String name;
  String email;
  String password;
  String profilePic;

  User();

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'profilePic': profilePic,
      };

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        password = json['password'],
        profilePic = json['profilePic'];
}
