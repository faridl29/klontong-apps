import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong/core/di/injector.dart';
import 'package:klontong/presentation/blocs/add/product_add_bloc.dart';
import 'package:klontong/presentation/blocs/delete/product_delete_bloc.dart';
import 'package:klontong/presentation/blocs/detail/product_detail_bloc.dart';
import 'package:klontong/presentation/blocs/list/product_list_bloc.dart';
import 'package:klontong/presentation/theme/app_theme.dart';
import 'package:klontong/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjector();
  final prefs = await SharedPreferences.getInstance();

  final sentryDsn = const String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue: '',
  );

  Future<void> runAppFn() async {
    runApp(KlontongApp(prefs: prefs));
  }

  if (sentryDsn.isNotEmpty) {
    await SentryFlutter.init((options) {
      options.dsn = sentryDsn;
      options.tracesSampleRate = 1.0;
    }, appRunner: runAppFn);
  } else {
    await runAppFn();
  }
}

class KlontongApp extends StatelessWidget {
  final SharedPreferences prefs;
  const KlontongApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductListBloc(getProducts: sl(), prefs: prefs),
        ),
        BlocProvider(create: (_) => ProductDetailBloc(sl())),
        BlocProvider(create: (_) => ProductAddBloc(sl())),
        BlocProvider(create: (_) => ProductDeleteBloc(sl())),
      ],
      child: MaterialApp(
        title: 'Klontong',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.productList,
      ),
    );
  }
}
