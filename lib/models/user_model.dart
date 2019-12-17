class User {
  String name;
  String email;
  String password;

  User();

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
      };

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        password = json['password'];
}
