import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/core/util/paginated_list.dart';
import 'package:klontong/domain/entities/product.dart';
import 'package:klontong/domain/usecases/get_products.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProducts getProducts;
  final SharedPreferences prefs;

  ProductListBloc({required this.getProducts, required this.prefs})
    : super(const ProductListState.initial()) {
    on<ProductListLoaded>(_onLoaded);
    on<ProductListPageChanged>(_onPageChanged);
    on<ProductListQueryChanged>(_onQueryChanged);
  }

  Future<void> _onLoaded(
    ProductListLoaded event,
    Emitter<ProductListState> emit,
  ) async {
    final lastQuery = prefs.getString('last_query') ?? '';
    final lastPage = prefs.getInt('last_page') ?? 0;
    await _fetch(emit, pageIndex: lastPage, query: lastQuery);
  }

  Future<void> _onPageChanged(
    ProductListPageChanged event,
    Emitter<ProductListState> emit,
  ) async {
    prefs.setInt('last_page', event.pageIndex);
    await _fetch(emit, pageIndex: event.pageIndex, query: state.query);
  }

  Future<void> _onQueryChanged(
    ProductListQueryChanged event,
    Emitter<ProductListState> emit,
  ) async {
    prefs.setString('last_query', event.query);
    await _fetch(emit, pageIndex: 0, query: event.query);
  }

  Future<void> _fetch(
    Emitter<ProductListState> emit, {
    required int pageIndex,
    required String query,
  }) async {
    try {
      emit(state.copyWith(status: ProductListStatus.loading));
      final result = await getProducts(
        pageIndex: pageIndex,
        pageSize: state.pageSize,
        query: query.isEmpty ? null : query,
      );
      emit(
        state.copyWith(
          status: ProductListStatus.success,
          data: result,
          query: query,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ProductListStatus.failure, error: e.toString()),
      );
    }
  }
}
