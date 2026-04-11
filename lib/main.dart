import 'package:admin_dashboard/controllers/auth_controller.dart';

import 'package:admin_dashboard/controllers/overView_controller.dart';
import 'package:admin_dashboard/screens/admin_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminAuthController()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
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
      home: const AdminLogin(),
    );
  }
}
