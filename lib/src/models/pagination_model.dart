class Pagination {
  int count;
  int currentPage;
  int perPage;
  int total;
  int totalPages;

  Pagination(
      {this.count = 0,
      this.currentPage = 0,
      this.perPage = 0,
      this.total = 0,
      this.totalPages = 0});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      count: json['count'] as int,
      currentPage: json['current_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
      totalPages: json['total_pages'] as int,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'count': count,
        'current_page': currentPage,
        'per_page': perPage,
        'total': total,
        'total_pages': totalPages,
      };
}

class Meta {
  final Pagination? pagination;
  bool? isValid;
  String? firstUnreadMessageId;
  Map<String, dynamic>? extra;
  Meta(this.pagination);

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      json['pagination'] == null
          ? null
          : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    )
      ..isValid = json['is_valid'] as bool?
      ..firstUnreadMessageId = json['first_unread_message_id'] as String?
      ..extra = json['extra'] as Map<String, dynamic>?;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'pagination': pagination,
    'is_valid': isValid,
    'first_unread_message_id': firstUnreadMessageId,
    'extra': extra,
  };
}

@Deprecated(
    "Use PaginationWrapper instead, only pass generic type model T, do not use List<T>")
class PaginationDataWrapper<T> {
  final T? data;
  final Meta? meta;

  PaginationDataWrapper(this.data, this.meta);
}

class PaginationWrapper<T> {
  final List<T>? data;
  final Meta? meta;

  PaginationWrapper(this.data, this.meta);
}
