import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:klontong/domain/usecases/delete_product.dart';
import 'package:klontong/presentation/blocs/delete/product_delete_bloc.dart';

class MockDeleteProduct extends Mock implements DeleteProduct {}

void main() {
  late MockDeleteProduct mockDeleteProduct;
  late ProductDeleteBloc bloc;

  const productId = "123";

  setUp(() {
    mockDeleteProduct = MockDeleteProduct();
    bloc = ProductDeleteBloc(mockDeleteProduct);
  });

  blocTest<ProductDeleteBloc, ProductDeleteState>(
    'emits [loading, success] when DeleteProduct succeeds',
    build: () {
      when(
        () => mockDeleteProduct(productId),
      ).thenAnswer((_) async => "deleted");

      return bloc;
    },
    act: (bloc) => bloc.add(ProductDeleted(productId)),
    expect:
        () => [
          isA<ProductDeleteState>().having(
            (s) => s.status,
            'status',
            ProductDeleteStatus.loading,
          ),
          isA<ProductDeleteState>().having(
            (s) => s.status,
            'status',
            ProductDeleteStatus.success,
          ),
        ],
    verify: (_) {
      verify(() => mockDeleteProduct(productId)).called(1);
    },
  );

  blocTest<ProductDeleteBloc, ProductDeleteState>(
    'emits [loading, failure] when DeleteProduct throws',
    build: () {
      when(
        () => mockDeleteProduct(productId),
      ).thenThrow(Exception('Delete failed'));
      return bloc;
    },
    act: (bloc) => bloc.add(ProductDeleted(productId)),
    expect:
        () => [
          isA<ProductDeleteState>().having(
            (s) => s.status,
            'status',
            ProductDeleteStatus.loading,
          ),
          isA<ProductDeleteState>().having(
            (s) => s.status,
            'status',
            ProductDeleteStatus.failure,
          ),
        ],
    verify: (_) {
      verify(() => mockDeleteProduct(productId)).called(1);
    },
  );
}
