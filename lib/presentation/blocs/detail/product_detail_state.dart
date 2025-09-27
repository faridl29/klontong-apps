part of 'product_detail_bloc.dart';

enum ProductDetailStatus { initial, loading, success, failure }

class ProductDetailState extends Equatable {
  final ProductDetailStatus status;
  final Product? product;
  final String? error;

  const ProductDetailState({required this.status, this.product, this.error});

  const ProductDetailState.initial()
    : this(status: ProductDetailStatus.initial);

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    Product? product,
    String? error,
  }) => ProductDetailState(
    status: status ?? this.status,
    product: product ?? this.product,
    error: error,
  );

  @override
  List<Object?> get props => [status, product, error];
}
