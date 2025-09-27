import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:klontong/domain/entities/product.dart';
import 'package:klontong/domain/usecases/get_products.dart';
import 'package:klontong/presentation/blocs/list/product_list_bloc.dart';
import 'package:klontong/core/util/paginated_list.dart';

class MockGetProducts extends Mock implements GetProducts {}

void main() {
  late MockGetProducts mockGetProducts;
  late SharedPreferences prefs;
  late ProductListBloc bloc;

  final tProducts = [
    Product(
      id: "aesf",
      categoryId: 14,
      categoryName: "Cemilan",
      sku: "MHZVTK",
      name: "Ciki ciki",
      description: "Ciki ciki yang super enak",
      weight: 500,
      width: 5,
      length: 5,
      height: 5,
      image: "https://cf.shopee.co.id/file/7cb930d1bd183a435f4fb3e5cc4a896b",
      price: 30000,
    ),
  ];

  setUp(() async {
    mockGetProducts = MockGetProducts();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    bloc = ProductListBloc(getProducts: mockGetProducts, prefs: prefs);
  });

  blocTest<ProductListBloc, ProductListState>(
    'emits [loading, success] when GetProducts returns data',
    build: () {
      when(
        () => mockGetProducts(
          pageIndex: any(named: 'pageIndex'),
          pageSize: any(named: 'pageSize'),
          query: any(named: 'query'),
        ),
      ).thenAnswer(
        (_) async => PaginatedList<Product>(
          items: tProducts,
          pageIndex: 0,
          pageSize: 10,
          totalItems: 1,
        ),
      );
      return bloc;
    },
    act: (bloc) => bloc.add(ProductListLoaded()),
    expect:
        () => [
          isA<ProductListState>().having(
            (s) => s.status,
            'status',
            ProductListStatus.loading,
          ),
          isA<ProductListState>().having(
            (s) => s.status,
            'status',
            ProductListStatus.success,
          ),
        ],
  );

  blocTest<ProductListBloc, ProductListState>(
    'emits [loading, failure] when GetProducts throws',
    build: () {
      when(
        () => mockGetProducts(
          pageIndex: any(named: 'pageIndex'),
          pageSize: any(named: 'pageSize'),
          query: any(named: 'query'),
        ),
      ).thenThrow(Exception('Network error'));
      return bloc;
    },
    act: (bloc) => bloc.add(ProductListLoaded()),
    expect:
        () => [
          isA<ProductListState>().having(
            (s) => s.status,
            'status',
            ProductListStatus.loading,
          ),
          isA<ProductListState>().having(
            (s) => s.status,
            'status',
            ProductListStatus.failure,
          ),
        ],
  );
}
