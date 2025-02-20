class DashboardModel {
  final String title;
  final int value;

  DashboardModel({required this.title, required this.value});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      title: json['title'],
      value: json['value'],
    );
  }
}
