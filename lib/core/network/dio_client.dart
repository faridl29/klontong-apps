import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;
  DioClient(this.dio) {
    dio.options
      ..baseUrl = const String.fromEnvironment(
        'CRUDCRUD_BASE_URL',
        defaultValue: '',
      )
      ..connectTimeout = const Duration(seconds: 15)
      ..receiveTimeout = const Duration(seconds: 20)
      ..headers = {'Content-Type': 'application/json'};
    dio.interceptors.add(LogInterceptor(responseBody: false));
  }
}
