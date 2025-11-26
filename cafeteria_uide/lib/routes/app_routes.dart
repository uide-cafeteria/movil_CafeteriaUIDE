import 'package:flutter/material.dart';

// Pantallas
import '../ui/screens/login_screen.dart';
import '../ui/pages/main_screen.dart'; // Esta será el home después del login

class AppRoutes {
  static const initialRoute = '/login';

  static final Map<String, WidgetBuilder> routes = {
    '/login': (_) => const LoginScreen(),
    '/main': (_) => const MainScreen(),
    '/home': (_) => const MainScreen()

  };
}
