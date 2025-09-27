class PaginatedList<T> {
  final List<T> items;
  final int pageIndex;
  final int pageSize;
  final int totalItems;

  PaginatedList({
    required this.items,
    required this.pageIndex,
    required this.pageSize,
    required this.totalItems,
  });

  PaginatedList<T> copyWith({
    List<T>? items,
    int? pageIndex,
    int? pageSize,
    int? totalItems,
  }) {
    return PaginatedList<T>(
      items: items ?? this.items,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}
