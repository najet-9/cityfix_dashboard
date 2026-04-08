/*import 'package:admin_dashboard/screens/admin_login.dart';
import 'package:admin_dashboard/screens/admin_shell.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_dashboard/controllers/auth_controller.dart';

class AdminWrapper extends StatelessWidget {
  const AdminWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AdminAuthController>();

    return StreamBuilder<User?>(
      stream: authController.authState,
      builder: (context, snapshot) {

        // [1] Firebase still initializing
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // [2] Logged in AND confirmed admin
        if (snapshot.hasData && authController.isAdmin) {
          return const AdminShell();
        }

        // [3] Not logged in, or logged in but not admin
        return const AdminLogin();
      },
    );
  }
}*/
