import 'package:admin_dashboard/controllers/auth_controller.dart';
import 'package:admin_dashboard/screens/admin_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  /* await dotenv.load(fileName: ".env");

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("a20c368d-e7a7-420b-8cdf-e6266b6e82ed");
  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    event.notification.display();
  });
  OneSignal.Notifications.requestPermission(true);*/
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AdminAuthController())],
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
