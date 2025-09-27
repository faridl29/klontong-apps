import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/domain/entities/product.dart';
import 'package:klontong/domain/usecases/get_product_detail.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductDetail getDetail;
  ProductDetailBloc(this.getDetail)
    : super(const ProductDetailState.initial()) {
    on<ProductDetailRequested>(_onRequested);
  }

  Future<void> _onRequested(
    ProductDetailRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ProductDetailStatus.loading));
      final product = await getDetail(event.id);
      emit(
        state.copyWith(status: ProductDetailStatus.success, product: product),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductDetailStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
