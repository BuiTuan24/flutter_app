import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/auth_repository.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/detail_screen.dart';
import 'Bloc_auth/auth_bloc.dart';  

void main() {
  final authRepo = AuthRepository(baseUrl: 'http://10.0.2.2:8080'); // IP localhost/Server của bạn

  runApp(
    BlocProvider(
      create: (_) => AuthBloc(authRepo: authRepo),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Mở app ra HomePage đầu tiên
      home: HomePage(),
      routes: {
        '/login': (_) => LoginPage(),
        '/register': (_) => RegisterPage(),
        '/detail': (_) => DetailScreen(),
      },
    );
  }
}