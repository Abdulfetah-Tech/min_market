import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:min_market/bloc/cart_bloc/cart_bloc.dart';
import 'package:min_market/bloc/product_bloc/product_bloc.dart';
import 'package:min_market/data/product_data_provider.dart';

import 'router.dart';

void main() {
  runApp(const MiniMarketApp());
}

class MiniMarketApp extends StatelessWidget {
  const MiniMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductBloc(ProductDataProvider())),
        BlocProvider(create: (context) => CartBloc()),
      ],

      child: MaterialApp.router(
        title: 'Mini Market',
        debugShowCheckedModeBanner: false,
        routerConfig: routes,
      ),
    );
  }
}
