import 'package:klontong/core/util/paginated_list.dart';
import 'package:klontong/domain/entities/product.dart';

abstract class ProductRepository {
  Future<PaginatedList<Product>> getProducts({
    required int pageIndex,
    required int pageSize,
    String? query,
  });
  Future<Product> getProductDetail(String id);
  Future<Product> addProduct(Product product);
  Future<String> deleteProduct(String id);
}
