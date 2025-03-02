class User {
  String id;
  String? userImage;
  String name;
  String email;
  String userName;
  String? phoneNumber;

  User({
    required this.id,
    this.userImage,
    required this.name,
    required this.email,
    required this.userName,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userImage: json['userImage'],
      name: json['name'],
      email: json['email'],
      userName: json['userName'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
