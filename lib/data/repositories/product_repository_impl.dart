import 'package:klontong/core/util/paginated_list.dart';
import 'package:klontong/data/datasources/product_remote_data_source.dart';
import 'package:klontong/data/models/product_model.dart';
import 'package:klontong/domain/entities/product.dart';
import 'package:klontong/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;
  ProductRepositoryImpl(this.remote);

  @override
  Future<Product> addProduct(Product product) async {
    final created = await remote.create(ProductModel.fromEntity(product));
    return created.toEntity();
  }

  @override
  Future<Product> getProductDetail(String id) async {
    final data = await remote.fetchById(id);
    return data.toEntity();
  }

  @override
  Future<PaginatedList<Product>> getProducts({
    required int pageIndex,
    required int pageSize,
    String? query,
  }) async {
    final all = await remote.fetchAll();
    final filtered =
        (query == null || query.trim().isEmpty)
            ? all
            : all
                .where(
                  (m) =>
                      m.name.toLowerCase().contains(query.toLowerCase()) ||
                      m.sku.toLowerCase().contains(query.toLowerCase()) ||
                      m.categoryName.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();

    final total = filtered.length;
    final start = pageIndex * pageSize;
    final end = (start + pageSize) > total ? total : (start + pageSize);
    final items =
        (start < total)
            ? filtered.reversed
                .toList()
                .sublist(start, end)
                .map((e) => e.toEntity())
                .toList()
            : <Product>[];

    return PaginatedList<Product>(
      items: items,
      pageIndex: pageIndex,
      pageSize: pageSize,
      totalItems: total,
    );
  }

  @override
  Future<String> deleteProduct(String id) async {
    final data = await remote.delete(id);
    return data;
  }
}
