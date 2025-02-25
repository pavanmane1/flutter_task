import 'package:flutter/material.dart';
import 'package:flutter_task/provider/auth_provider.dart';
import 'package:flutter_task/provider/currency_probvider.dart';
import 'package:flutter_task/provider/getcurrencyData_provider.dart';
import 'package:flutter_task/screens/login_screen.dart';
import 'package:flutter_task/services/services.dart';
import 'package:flutter_task/widgets/bottomnavigationbar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CountryProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider(apiService: ApiService())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Task',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {'/login': (context) => const LoginScreen(), '/home': (context) => const BottomNavBar()},
    );
  }
}
