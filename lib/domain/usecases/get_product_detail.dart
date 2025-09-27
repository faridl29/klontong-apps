import 'package:klontong/domain/entities/product.dart';
import 'package:klontong/domain/repositories/product_repository.dart';

class GetProductDetail {
  final ProductRepository repo;
  GetProductDetail(this.repo);
  Future<Product> call(String id) => repo.getProductDetail(id);
}
