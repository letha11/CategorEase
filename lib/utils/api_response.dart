class ApiResponse<T> {
  final bool error;
  final String? message;
  final T? data;

  ApiResponse({
    this.error = false,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T data) {
    return ApiResponse(
      error: json['error'],
      message: json['message'],
      data: data,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> dataJson) {
    return {
      'error': error,
      'message': message,
      'data': dataJson,
    };
  }
}

class PaginationApiResponse<T> {
  final int totalPage;
  final int recordPerPage;
  final int currentPage;
  final int? previous;
  final int? next;
  final List<T> data;

  PaginationApiResponse({
    required this.totalPage,
    required this.recordPerPage,
    required this.currentPage,
    this.previous,
    this.next,
    required this.data,
  });

  factory PaginationApiResponse.fromJson(
    Map<String, dynamic> json,
    List<T> data,
  ) {
    return PaginationApiResponse(
      totalPage: json['total_page'],
      recordPerPage: json['record_per_page'],
      currentPage: json['current_page'],
      previous: json['previous'],
      next: json['next'],
      data: data,
    );
  }

  Map<String, dynamic> toJson(List<Map<String, dynamic>> dataJson) {
    return {
      'total_page': totalPage,
      'record_per_page': recordPerPage,
      'current_page': currentPage,
      'previous': previous,
      'next': next,
      'data': dataJson,
    };
  }
}
