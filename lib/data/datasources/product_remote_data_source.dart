import 'package:dio/dio.dart';
import 'package:klontong/core/error/exceptions.dart';
import 'package:klontong/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchAll();
  Future<ProductModel> fetchById(String id);
  Future<ProductModel> create(ProductModel model);
  Future<String> delete(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;
  ProductRemoteDataSourceImpl(this.dio);

  String get _collection => const String.fromEnvironment(
    'PRODUCTS_COLLECTION',
    defaultValue: 'products',
  );

  @override
  Future<List<ProductModel>> fetchAll() async {
    try {
      final res = await dio.get('/$_collection');
      final data = (res.data as List).cast<Map<String, dynamic>>();
      return data.map(ProductModel.fromJson).toList();
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<ProductModel> fetchById(String id) async {
    try {
      final res = await dio.get('/$_collection/$id');
      return ProductModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<ProductModel> create(ProductModel model) async {
    try {
      final payload = model.toJson()..remove('_id');
      final res = await dio.post('/$_collection', data: payload);
      return ProductModel.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<String> delete(String id) async {
    try {
      final res = await dio.delete('/$_collection/$id');
      return res.data;
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
