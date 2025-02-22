class University {
  String name;
  String location;

  University({required this.name, required this.location});

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      location: json['location'],
    );
  }
}