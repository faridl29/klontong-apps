part of 'product_add_bloc.dart';

enum ProductAddStatus { initial, submitting, success, failure }

class ProductAddState extends Equatable {
  final ProductAddStatus status;
  final Product? created;
  final String? error;

  const ProductAddState({required this.status, this.created, this.error});

  const ProductAddState.initial() : this(status: ProductAddStatus.initial);

  ProductAddState copyWith({
    ProductAddStatus? status,
    Product? created,
    String? error,
  }) => ProductAddState(
    status: status ?? this.status,
    created: created ?? this.created,
    error: error,
  );

  @override
  List<Object?> get props => [status, created, error];
}
