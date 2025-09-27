part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductDetailRequested extends ProductDetailEvent {
  final String id;
  ProductDetailRequested(this.id);
  @override
  List<Object?> get props => [id];
}
