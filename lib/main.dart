import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shipping_address/common/routes/route.dart';
import 'package:shipping_address/common/widgets/custom_loading.dart';
import 'package:shipping_address/src/auth/providers/auth_provider.dart';
import 'package:shipping_address/src/customer_address/providers/customer_provider.dart';
part './common/helper/base_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<LoadingProvider>(
          create: (context) => LoadingProvider(),
        ),
        ChangeNotifierProvider<CustomerProvider>(
          create: (context) => CustomerProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: AppRoute.routes,
        builder: (context, child) {
          return Stack(children: [child!, const LoadingOverlay()]);
        },
      ),
    );
  }
}
