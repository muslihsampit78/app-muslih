class PaginationMeta {
  final int currentPage;
  final int? from;
  final int lastPage;
  final int perPage;
  final int? to;
  final int total;

  PaginationMeta({
    required this.currentPage,
    this.from,
    required this.lastPage,
    required this.perPage,
    this.to,
    required this.total,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] as int? ?? 1,
      from: json['from'] as int?,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 15,
      to: json['to'] as int?,
      total: json['total'] as int? ?? 0,
    );
  }
}

class PaginatedList<T> {
  final List<T> data;
  final PaginationMeta? meta;

  PaginatedList({required this.data, this.meta});

  bool get hasMore =>
      meta != null && meta!.currentPage < meta!.lastPage;
}

