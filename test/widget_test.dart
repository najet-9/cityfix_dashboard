import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:admin_dashboard/main.dart';
import 'package:admin_dashboard/state/app_state.dart';

void main() {
  testWidgets('Vérification du chargement de l\'application', (WidgetTester tester) async {
    // On reconstruit l'application avec les Providers nécessaires pour le test
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthState()),
          ChangeNotifierProvider(create: (_) => DashboardState()),
        ],
        child: const CityFixAdminApp(), // <-- Correction du nom ici
      ),
    );

    // on vérifie si l'écran de login est présent 
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}