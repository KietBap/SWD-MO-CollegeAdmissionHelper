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
      id: json['id'] ?? '',
      userImage: json['userImage'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      userName: json['userName'] ?? '',
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id.isNotEmpty ? id : "";
    data['userImage'] = (userImage != null && userImage!.isNotEmpty) ? userImage : "";
    data['name'] = name.isNotEmpty ? name : "";
    data['email'] = email.isNotEmpty ? email : "";
    data['userName'] = userName.isNotEmpty ? userName : "";
    data['phoneNumber'] = (phoneNumber != null && phoneNumber!.isNotEmpty) ? phoneNumber : "";

    return data;
  }
}
