import 'package:klontong/domain/entities/product.dart';
import 'package:klontong/domain/repositories/product_repository.dart';

class AddProduct {
  final ProductRepository repo;
  AddProduct(this.repo);
  Future<Product> call(Product product) => repo.addProduct(product);
}
