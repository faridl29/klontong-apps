import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:klontong/domain/entities/product.dart';
import 'package:klontong/domain/usecases/add_product.dart';
import 'package:klontong/presentation/blocs/add/product_add_bloc.dart';

class MockAddProduct extends Mock implements AddProduct {}

void main() {
  late MockAddProduct mockAddProduct;
  late ProductAddBloc bloc;

  final newProduct = Product(
    id: "aefef",
    categoryId: 20,
    categoryName: "Minuman",
    sku: "ABC123",
    name: "Teh Botol",
    description: "Teh botol segar",
    weight: 450,
    width: 5,
    length: 5,
    height: 15,
    image: "https://picsum.photos/200",
    price: 5000,
  );

  setUp(() {
    mockAddProduct = MockAddProduct();
    bloc = ProductAddBloc(mockAddProduct);
  });

  blocTest<ProductAddBloc, ProductAddState>(
    'emits [submitting, success] when AddProduct succeeds',
    build: () {
      when(
        () => mockAddProduct(newProduct),
      ).thenAnswer((_) async => newProduct);
      return bloc;
    },
    act: (bloc) => bloc.add(ProductSubmitted(newProduct)),
    expect:
        () => [
          isA<ProductAddState>().having(
            (s) => s.status,
            'status',
            ProductAddStatus.submitting,
          ),
          isA<ProductAddState>().having(
            (s) => s.status,
            'status',
            ProductAddStatus.success,
          ),
        ],
  );

  blocTest<ProductAddBloc, ProductAddState>(
    'emits [submitting, failure] when AddProduct throws',
    build: () {
      when(
        () => mockAddProduct(newProduct),
      ).thenThrow(Exception('Failed to save'));
      return bloc;
    },
    act: (bloc) => bloc.add(ProductSubmitted(newProduct)),
    expect:
        () => [
          isA<ProductAddState>().having(
            (s) => s.status,
            'status',
            ProductAddStatus.submitting,
          ),
          isA<ProductAddState>().having(
            (s) => s.status,
            'status',
            ProductAddStatus.failure,
          ),
        ],
  );
}
