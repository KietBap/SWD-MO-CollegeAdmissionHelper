class PaginatedResponse<T> {
  List<T> items;
  int totalItems;
  int currentPage;
  int totalPages;
  int pageSize;
  bool hasPreviousPage;
  bool hasNextPage;

  PaginatedResponse({
    required this.items,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
  return PaginatedResponse<T>(
    items: (json['message']['items']['\$values'] as List?)?.map((item) => fromJsonT(item)).toList() ?? [], 
    totalItems: json['message']['totalItems'] ?? 0,
    currentPage: json['message']['currentPage'] ?? 1,
    totalPages: json['message']['totalPages'] ?? 0,
    pageSize: json['message']['pageSize'] ?? 5,
    hasPreviousPage: json['message']['hasPreviousPage'] ?? false,
    hasNextPage: json['message']['hasNextPage'] ?? false,
  );
}


  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'items': items.map((item) => toJsonT(item)).toList(),
      'totalItems': totalItems,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'pageSize': pageSize,
      'hasPreviousPage': hasPreviousPage,
      'hasNextPage': hasNextPage,
    };
  }
}
