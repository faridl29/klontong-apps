import 'package:flutter/material.dart';
import 'package:klontong/presentation/pages/product_detail_page.dart';
import 'package:klontong/presentation/pages/product_form_page.dart';
import 'package:klontong/presentation/pages/product_list_page.dart';

class AppRouter {
  static const productList = '/';
  static const productDetail = '/detail';
  static const productForm = '/form';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case productList:
        return MaterialPageRoute(builder: (_) => const ProductListPage());
      case productDetail:
        final id = settings.arguments as String;
        return MaterialPageRoute(builder: (ctx) => ProductDetailPage(id: id));
      case productForm:
        return MaterialPageRoute(builder: (ctx) => const ProductFormPage());
      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(body: Center(child: Text('Not Found'))),
        );
    }
  }
}
