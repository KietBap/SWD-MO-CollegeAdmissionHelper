class Major {
  final String id;
  final String name;
  final String? relatedSkills;
  final String? description;

  Major({
    required this.id,
    required this.name,
    this.relatedSkills,
    this.description,
  });

  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(
      id: json['id'],
      name: json['name'],
      relatedSkills: json['relatedSkills'] as String?,
      description: json['description'] as String?,
    );
  }
}
