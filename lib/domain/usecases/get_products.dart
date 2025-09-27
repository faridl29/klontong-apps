import 'package:klontong/core/util/paginated_list.dart';
import 'package:klontong/domain/entities/product.dart';
import 'package:klontong/domain/repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repo;
  GetProducts(this.repo);
  Future<PaginatedList<Product>> call({
    required int pageIndex,
    required int pageSize,
    String? query,
  }) =>
      repo.getProducts(pageIndex: pageIndex, pageSize: pageSize, query: query);
}
