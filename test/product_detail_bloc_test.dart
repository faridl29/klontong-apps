import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:klontong/domain/entities/product.dart';
import 'package:klontong/domain/usecases/get_product_detail.dart';
import 'package:klontong/presentation/blocs/detail/product_detail_bloc.dart';

class MockGetProductDetail extends Mock implements GetProductDetail {}

void main() {
  late MockGetProductDetail mockGetDetail;
  late ProductDetailBloc bloc;

  const productId = "1";

  final tProduct = Product(
    id: "awdwd",
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
  );

  setUp(() {
    mockGetDetail = MockGetProductDetail();
    bloc = ProductDetailBloc(mockGetDetail);
  });

  blocTest<ProductDetailBloc, ProductDetailState>(
    'emits [loading, success] when GetProductDetail returns product',
    build: () {
      when(() => mockGetDetail(productId)).thenAnswer((_) async => tProduct);
      return bloc;
    },
    act: (bloc) => bloc.add(ProductDetailRequested(productId)),
    expect:
        () => [
          isA<ProductDetailState>().having(
            (s) => s.status,
            'status',
            ProductDetailStatus.loading,
          ),
          isA<ProductDetailState>().having(
            (s) => s.status,
            'status',
            ProductDetailStatus.success,
          ),
        ],
  );

  blocTest<ProductDetailBloc, ProductDetailState>(
    'emits [loading, failure] when GetProductDetail throws',
    build: () {
      when(() => mockGetDetail(productId)).thenThrow(Exception('404'));
      return bloc;
    },
    act: (bloc) => bloc.add(ProductDetailRequested(productId)),
    expect:
        () => [
          isA<ProductDetailState>().having(
            (s) => s.status,
            'status',
            ProductDetailStatus.loading,
          ),
          isA<ProductDetailState>().having(
            (s) => s.status,
            'status',
            ProductDetailStatus.failure,
          ),
        ],
  );
}
