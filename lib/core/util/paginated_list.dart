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
}
