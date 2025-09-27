part of 'product_delete_bloc.dart';

abstract class ProductDeleteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductDeleted extends ProductDeleteEvent {
  final String id;
  ProductDeleted(this.id);
  @override
  List<Object?> get props => [id];
}
