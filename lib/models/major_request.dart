class MajorRequest {
  final String name;
  final String? relatedSkills;
  final String? description;

  MajorRequest({
    required this.name,
    this.relatedSkills,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "relatedSkills": relatedSkills,
      "description": description,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    final Map<String, dynamic> data = {};

    if (name.isNotEmpty)
      data["name"] = name;
    else
      data["name"] = "";
    if (description?.isNotEmpty == true)
      data["description"] = description;
    else
      data["description"] = "";
    if (relatedSkills?.isNotEmpty == true)
      data["relatedSkills"] = relatedSkills;
    else
      data["relatedSkills"] = "";
    return data;
  }
}
