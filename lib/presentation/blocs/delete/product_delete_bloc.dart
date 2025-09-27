import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/domain/entities/product.dart';
import 'package:klontong/domain/usecases/delete_product.dart';

part 'product_delete_event.dart';
part 'product_delete_state.dart';

class ProductDeleteBloc extends Bloc<ProductDeleteEvent, ProductDeleteState> {
  final DeleteProduct delete;
  ProductDeleteBloc(this.delete) : super(const ProductDeleteState.initial()) {
    on<ProductDeleted>(_onRequested);
  }

  Future<void> _onRequested(
    ProductDeleted event,
    Emitter<ProductDeleteState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ProductDeleteStatus.loading));
      await delete(event.id);
      emit(state.copyWith(status: ProductDeleteStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductDeleteStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
