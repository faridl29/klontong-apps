part of 'product_add_bloc.dart';

abstract class ProductAddEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductSubmitted extends ProductAddEvent {
  final Product product;
  ProductSubmitted(this.product);
  @override
  List<Object?> get props => [product];
}
