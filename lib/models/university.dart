class University {
  final String id;
  final String name;
  final String location;
  final String universityCode;
  final String email;
  final String phoneNumber;
  final String type;
  final int rankingNational;
  final int rankingInternational;
  final String image;

  University({
    required this.id,
    required this.name,
    required this.location,
    required this.universityCode,
    required this.email,
    required this.phoneNumber,
    required this.type,
    required this.rankingNational,
    required this.rankingInternational,
    required this.image,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      universityCode: json['universityCode'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      type: json['type'] ?? '',
      rankingNational: json['rankingNational'] ?? 0,
      rankingInternational: json['rankingInternational'] ?? 0,
      image: json['image'] ?? '',
    );
  }
}
