part of 'product_list_bloc.dart';

enum ProductListStatus { initial, loading, success, failure, loadingMore }

class ProductListState extends Equatable {
  final ProductListStatus status;
  final PaginatedList<Product>? data;
  final String query;
  final int pageSize;
  final String? error;

  const ProductListState({
    required this.status,
    this.data,
    required this.query,
    required this.pageSize,
    this.error,
  });

  const ProductListState.initial()
    : status = ProductListStatus.initial,
      data = null,
      query = '',
      pageSize = 10,
      error = null;

  ProductListState copyWith({
    ProductListStatus? status,
    PaginatedList<Product>? data,
    String? query,
    int? pageSize,
    String? error,
  }) => ProductListState(
    status: status ?? this.status,
    data: data ?? this.data,
    query: query ?? this.query,
    pageSize: pageSize ?? this.pageSize,
    error: error,
  );

  @override
  List<Object?> get props => [status, data, query, pageSize, error];
}
