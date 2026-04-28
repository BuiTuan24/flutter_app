import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/auth_repository.dart';
import 'package:flutter_application_1/screen_model/theme.dart';
import 'package:flutter_application_1/screen_model/theme_provider.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/detail_screen.dart';
import 'Bloc_auth/auth_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  final authRepo = AuthRepository(baseUrl: 'http://10.0.2.2:8080');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(create: (_) => AuthBloc(authRepo: authRepo)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode:
      themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,

      home: HomePage(),

      routes: {
        '/login': (_) => LoginPage(),
        '/register': (_) => RegisterPage(),
        '/detail': (_) => DetailScreen(),
      },
    );
  }
}