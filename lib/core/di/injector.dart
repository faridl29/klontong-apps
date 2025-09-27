import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:klontong/core/network/dio_client.dart';
import 'package:klontong/core/storage/secure_storage.dart';
import 'package:klontong/data/datasources/product_remote_data_source.dart';
import 'package:klontong/data/repositories/product_repository_impl.dart';
import 'package:klontong/domain/repositories/product_repository.dart';
import 'package:klontong/domain/usecases/add_product.dart';
import 'package:klontong/domain/usecases/delete_product.dart';
import 'package:klontong/domain/usecases/get_product_detail.dart';
import 'package:klontong/domain/usecases/get_products.dart';

final sl = GetIt.instance;

Future<void> initInjector() async {
  // Network
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<DioClient>(() => DioClient(sl()));

  // Storage
  sl.registerLazySingleton<SecureStorage>(
    () => SecureStorage(const FlutterSecureStorage()),
  );

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductDetail(sl()));
  sl.registerLazySingleton(() => AddProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));
}
