part of 'product_list_bloc.dart';

enum ProductListEventType { load, pageChanged, queryChanged }

abstract class ProductListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductListLoaded extends ProductListEvent {}

class ProductListPageChanged extends ProductListEvent {
  final int pageIndex;
  ProductListPageChanged(this.pageIndex);
  @override
  List<Object?> get props => [pageIndex];
}

class ProductListQueryChanged extends ProductListEvent {
  final String query;
  ProductListQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}
