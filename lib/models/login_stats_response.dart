class LoginStatsResponse {
  final String message;
  final LoginStatsData data;

  LoginStatsResponse({
    required this.message,
    required this.data,
  });

  factory LoginStatsResponse.fromJson(Map<String, dynamic> json) {
    return LoginStatsResponse(
      message: json['message'] as String? ?? '',
      data: LoginStatsData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['message'] = message.isNotEmpty ? message : '';
    json['data'] = data.toJson();
    return json;
  }
}

class LoginStatsData {
  final List<LoginStat> values;

  LoginStatsData({
    required this.values,
  });

  factory LoginStatsData.fromJson(Map<String, dynamic> json) {
    final valuesList = json['\$values'] as List<dynamic>? ?? [];
    return LoginStatsData(
      values: valuesList
          .map((item) => LoginStat.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['\$values'] = values.map((item) => item.toJson()).toList();
    return json;
  }
}

class LoginStat {
  final String userId;
  final String userName;
  final int loginCount;
  final DateTime loginTime;

  LoginStat({
    required this.userId,
    required this.userName,
    required this.loginCount,
    required this.loginTime,
  });

  factory LoginStat.fromJson(Map<String, dynamic> json) {
    return LoginStat(
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      loginCount: json['loginCount'] as int? ?? 0,
      loginTime: _parseDateTime(json['loginTime'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['userId'] = userId.isNotEmpty ? userId : '';
    json['userName'] = userName.isNotEmpty ? userName : '';
    json['loginCount'] = loginCount > 0 ? loginCount : 0;
    json['loginTime'] = loginTime.year != 1 ? loginTime.toIso8601String() : '';
    return json;
  }

  static DateTime _parseDateTime(String? date) {
    if (date == null || date.isEmpty) {
      return DateTime.now();
    }
    try {
      final parsedDate = DateTime.parse(date);
      // Check if the date is the default "0001-01-01" value
      if (parsedDate.year == 1) {
        return DateTime.now();
      }
      return parsedDate;
    } catch (e) {
      return DateTime.now();
    }
  }
}