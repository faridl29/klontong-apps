import 'package:klontong/domain/entities/product.dart';

class ProductModel {
  final String? id;
  final int categoryId;
  final String categoryName;
  final String sku;
  final String name;
  final String description;
  final int weight;
  final int width;
  final int length;
  final int height;
  final String image;
  final int price;

  ProductModel({
    this.id,
    required this.categoryId,
    required this.categoryName,
    required this.sku,
    required this.name,
    required this.description,
    required this.weight,
    required this.width,
    required this.length,
    required this.height,
    required this.image,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['_id'] as String?,
    categoryId: (json['CategoryId'] ?? json['categoryId']) as int,
    categoryName: json['categoryName'] as String,
    sku: json['sku'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    weight: json['weight'] as int,
    width: json['width'] as int,
    length: json['length'] as int,
    height: json['height'] as int,
    image: json['image'] as String,
    price: json['price'] as int,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'CategoryId': categoryId,
    'categoryName': categoryName,
    'sku': sku,
    'name': name,
    'description': description,
    'weight': weight,
    'width': width,
    'length': length,
    'height': height,
    'image': image,
    'price': price,
  };

  Product toEntity() => Product(
    id: id ?? '',
    categoryId: categoryId,
    categoryName: categoryName,
    sku: sku,
    name: name,
    description: description,
    weight: weight,
    width: width,
    length: length,
    height: height,
    image: image,
    price: price,
  );

  static ProductModel fromEntity(Product e) => ProductModel(
    id: e.id.isEmpty ? null : e.id,
    categoryId: e.categoryId,
    categoryName: e.categoryName,
    sku: e.sku,
    name: e.name,
    description: e.description,
    weight: e.weight,
    width: e.width,
    length: e.length,
    height: e.height,
    image: e.image,
    price: e.price,
  );
}
