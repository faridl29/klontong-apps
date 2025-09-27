part of 'product_delete_bloc.dart';

enum ProductDeleteStatus { initial, loading, success, failure }

class ProductDeleteState extends Equatable {
  final ProductDeleteStatus status;
  final Product? product;
  final String? error;

  const ProductDeleteState({required this.status, this.product, this.error});

  const ProductDeleteState.initial()
    : this(status: ProductDeleteStatus.initial);

  ProductDeleteState copyWith({ProductDeleteStatus? status, String? error}) =>
      ProductDeleteState(status: status ?? this.status, error: error);

  @override
  List<Object?> get props => [status, product, error];
}
