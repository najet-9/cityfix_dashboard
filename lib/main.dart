import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_dashboard/screens/admin_login.dart';
import 'package:admin_dashboard/screens/overview_page.dart';
import 'package:admin_dashboard/screens/admin_shell.dart';
import 'package:admin_dashboard/state/app_state.dart';
import 'package:admin_dashboard/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => DashboardState()),
      ],
      child: const CityFixAdminApp(),
    ),
  );
}

class CityFixAdminApp extends StatelessWidget {
  const CityFixAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityFix — Admin Dashboard',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Écoute les changements d'authentification
    final authState = context.watch<AuthState>();

    if (authState.isAuthenticated) {
      // Si connecté, on affiche le Shell
      return const AdminShell();
    } else {
      // Sinon on affiche l'écran de login
      return const AdminLogin();
    }
  }
}
