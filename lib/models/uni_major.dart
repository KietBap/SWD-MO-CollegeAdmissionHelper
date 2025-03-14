class UniMajor {
  final String id;
  final String tuitionFee;
  final String majorCode;
  final String universityName;
  final String majorName;

  UniMajor({
    required this.id,
    required this.tuitionFee,
    required this.majorCode,
    required this.universityName,
    required this.majorName,
  });

  factory UniMajor.fromJson(Map<String, dynamic> json) {
    return UniMajor(
      id: json['Id']?.toString() ?? '',
      tuitionFee: json['TuitionFee'] ?? '',
      majorCode: json['MajorCode'] ?? '',
      universityName: json['UniversityName'] ?? '',
      majorName: json['MajorName'] ?? '',
    );
  }
}
