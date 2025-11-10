class ApiResponse<T> {
  final bool status;
  final int statusCode;
  final String? message;
  final T? data;
  final PaginationMeta? meta;
  final PaginationLinks? links;
  final List<String>? errors;

  const ApiResponse({
    required this.status,
    required this.statusCode,
    this.message,
    this.data,
    this.meta,
    this.links,
    this.errors,
  });

  // Factory constructor for normal responses
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] ?? false,
      statusCode: json['status_code'] ?? 500,
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: _parseErrors(json['errors']),
    );
  }

  // Factory constructor for paginated responses
  factory ApiResponse.fromPaginatedJson(
    Map<String, dynamic> json,
    T Function(List<dynamic>) fromJsonT,
  ) {
    final data = json['data'] as Map<String, dynamic>?;

    return ApiResponse<T>(
      status: json['status'] ?? false,
      statusCode: json['status_code'] ?? 500,
      message: json['message'],
      data: data != null && data['items'] != null
          ? fromJsonT(data['items'] as List<dynamic>)
          : null,
      meta: data?['meta'] != null
          ? PaginationMeta.fromJson(data!['meta'] as Map<String, dynamic>)
          : null,
      links: data?['links'] != null
          ? PaginationLinks.fromJson(data!['links'] as Map<String, dynamic>)
          : null,
      errors: _parseErrors(json['errors']),
    );
  }

  // Factory constructor for list responses (normal non-paginated)
  factory ApiResponse.fromListJson(
    Map<String, dynamic> json,
    T Function(List<dynamic>) fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] ?? false,
      statusCode: json['status_code'] ?? 500,
      message: json['message'],
      data: json['data'] != null
          ? fromJsonT(json['data'] as List<dynamic>)
          : null,
      errors: _parseErrors(json['errors']),
    );
  }

  // Factory constructor for error responses
  factory ApiResponse.error({
    required int statusCode,
    required String message,
    dynamic data,
    List<String>? errors,
  }) {
    return ApiResponse<T>(
      status: false,
      statusCode: statusCode,
      message: message,
      data: data,
      errors: errors,
    );
  }

  // Check if response is successful
  bool get isSuccess => status && statusCode >= 200 && statusCode < 300;

  // Check if response is paginated
  bool get isPaginated => meta != null && links != null;

  @override
  String toString() {
    return 'ApiResponse(status: $status, statusCode: $statusCode, message: $message, data: $data, meta: $meta, links: $links)';
  }

  // Helper method to parse errors that can be either String or List
  static List<String> _parseErrors(dynamic errors) {
    if (errors == null) return [];
    if (errors is String) return [errors];
    if (errors is List) return errors.map((e) => e.toString()).toList();
    return [errors.toString()];
  }
}

// Pagination meta information
class PaginationMeta {
  final int currentPage;
  final int? from;
  final int lastPage;
  final int perPage;
  final int? to;
  final int total;

  const PaginationMeta({
    required this.currentPage,
    this.from,
    required this.lastPage,
    required this.perPage,
    this.to,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? 1,
      from: json['from'],
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      to: json['to'],
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'from': from,
      'last_page': lastPage,
      'per_page': perPage,
      'to': to,
      'total': total,
    };
  }

  @override
  String toString() {
    return 'PaginationMeta(currentPage: $currentPage, from: $from, lastPage: $lastPage, perPage: $perPage, to: $to, total: $total)';
  }
}

// Pagination links information
class PaginationLinks {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  const PaginationLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory PaginationLinks.fromJson(Map<String, dynamic> json) {
    return PaginationLinks(
      first: json['first'],
      last: json['last'],
      prev: json['prev'],
      next: json['next'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'last': last,
      'prev': prev,
      'next': next,
    };
  }

  @override
  String toString() {
    return 'PaginationLinks(first: $first, last: $last, prev: $prev, next: $next)';
  }
}
