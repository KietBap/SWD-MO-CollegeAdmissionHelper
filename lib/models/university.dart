import 'uni_major.dart';

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
  final String accreditation;
  final String description;
  final DateTime establishedDate;
  final List<UniMajor> majors;

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
    required this.accreditation,
    required this.description,
    required this.establishedDate,
    required this.majors,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    final majorsList = json['Majors'];
    return University(
      id: json['Id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['Name'] ?? json['name'] ?? '',
      location: json['Location'] ?? json['location'] ?? '',
      universityCode: json['UniversityCode'] ?? json['universityCode'] ?? '',
      email: json['Email'] ?? json['email'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? json['phoneNumber'] ?? '',
      type: json['Type'] ?? json['type'] ?? '',
      rankingNational: json['RankingNational'] is int
          ? json['RankingNational']
          : int.tryParse(json['rankingNational']?.toString() ?? '0') ?? 0,
      rankingInternational: json['RankingInternational'] is int
          ? json['RankingInternational']
          : int.tryParse(json['rankingInternational']?.toString() ?? '0') ?? 0,
      image: json['Image'] ?? json['image'] ?? '',
      accreditation: json['Accreditation'] ?? json['accreditation'] ?? '',
      description: json['Description'] ?? json['description'] ?? '',
      establishedDate: DateTime.tryParse(json['EstablishedDate'] ?? json['establishedDate'] ?? '') ??
          DateTime(2000),
      majors: majorsList != null
          ? (majorsList is List
              ? majorsList.map((m) => UniMajor.fromJson(m as Map<String, dynamic>)).toList()
              : majorsList['\$values'] != null
                  ? (majorsList['\$values'] as List).map((m) => UniMajor.fromJson(m)).toList()
                  : [])
          : [],
    );
  }
  }