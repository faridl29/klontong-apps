import 'package:klontong/domain/repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repo;
  DeleteProduct(this.repo);
  Future<String> call(String id) => repo.deleteProduct(id);
}
