class AIResponse {
  final String content;

  AIResponse({required this.content});

  factory AIResponse.fromJson(Map<String, dynamic> json) {
    return AIResponse(
      content: json["message"]["content"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "content": content,
    };
  }
}
