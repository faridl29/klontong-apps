import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';

const crudKey = 'b4ba00a5f3554cab93e42d624c31cb91';
const collection = 'products';
final baseUrl = 'https://crudcrud.com/api/$crudKey/$collection';

final categories = [
  {'id': 10, 'name': 'Cemilan'},
  {'id': 20, 'name': 'Minuman'},
  {'id': 30, 'name': 'Bumbu'},
  {'id': 40, 'name': 'Sembako'},
];

final random = Random();

String randomSku() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
}

Map<String, dynamic> generateProduct(int index) {
  final category = categories[random.nextInt(categories.length)];
  return {
    "id": index + 1,
    "categoryId": category['id'],
    "categoryName": category['name'],
    "sku": randomSku(),
    "name": "Produk ${index + 1}",
    "description": "Deskripsi produk ${index + 1} dari toko Klontong",
    "weight": 100 + random.nextInt(900), // gram
    "width": 5 + random.nextInt(15),
    "length": 5 + random.nextInt(15),
    "height": 5 + random.nextInt(15),
    "image": "https://picsum.photos/seed/product$index/400/400",
    "price": 5000 + random.nextInt(95000),
  };
}

Future<void> main() async {
  final dio = Dio();

  for (var i = 0; i < 20; i++) {
    final product = generateProduct(i);
    try {
      await dio.post(baseUrl, data: jsonEncode(product));
    } catch (e) {
      print("Failed to create product ${i + 1}: $e");
    }
  }

  print("Done seeding 20 products!");
}
