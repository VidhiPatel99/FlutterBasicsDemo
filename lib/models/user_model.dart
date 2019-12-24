class User {
  String name;
  String email;
  String password;
  String profilePic;
  String city;
  String countryCode;
  String phoneNumber;
  String gender;

  User();

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'profilePic': profilePic,
        'city': city,
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'gender': gender,
      };

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        password = json['password'],
        profilePic = json['profilePic'],
        city = json['city'],
        countryCode = json['countryCode'],
        phoneNumber = json['phoneNumber'],
        gender = json['gender'];
}
