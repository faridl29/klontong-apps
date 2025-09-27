import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/domain/entities/product.dart';
import 'package:klontong/domain/usecases/add_product.dart';

part 'product_add_event.dart';
part 'product_add_state.dart';

class ProductAddBloc extends Bloc<ProductAddEvent, ProductAddState> {
  final AddProduct addProduct;
  ProductAddBloc(this.addProduct) : super(const ProductAddState.initial()) {
    on<ProductSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ProductSubmitted event,
    Emitter<ProductAddState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ProductAddStatus.submitting));
      final created = await addProduct(event.product);
      emit(state.copyWith(status: ProductAddStatus.success, created: created));
    } catch (e) {
      emit(
        state.copyWith(status: ProductAddStatus.failure, error: e.toString()),
      );
    }
  }
}
