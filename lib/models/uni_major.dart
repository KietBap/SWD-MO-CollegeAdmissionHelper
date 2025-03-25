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
      id: json['id']?.toString() ?? json['Id']?.toString() ??'',
      tuitionFee: json['tuitionFee'] ?? json['TuitionFee']?.toString() ??'',
      majorCode: json['majorCode'] ?? json['MajorCode']?.toString() ?? '',
      universityName: json['universityName'] ?? json['UniversityName']?.toString() ?? '',
      majorName: json['majorName'] ?? json['MajorName']?.toString() ?? '',
    );
  }
}
