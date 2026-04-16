import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

//  SettingsController — gère les paramètres dans Firestore
//  + cache local via SharedPreferences

class SettingsController extends GetxController {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // État réactif (RxBool) — l'UI se met à jour auto
  final newReportAlerts = true.obs;
  final highConfirmAlerts = true.obs;
  final weeklyDigest = false.obs;
  final arabicLanguage = true.obs;
  final frenchTranslation = true.obs;

  // Chargement en cours
  final isLoading = false.obs;
  final isSaving = false.obs;

  //  Message de retour
  String? lastError;

  //  Cycle de vie GetX

  @override
  void onInit() {
    super.onInit();
    _loadSettings(); // charge au démarrage
  }

  //  ID de l'admin connecté

  String get _adminId => _auth.currentUser?.uid ?? 'default_admin';

  // Référence au document Firestore
  DocumentReference get _settingsDoc =>
      _db.collection('settings').doc(_adminId);

  //  CHARGER les paramètres
  //  Ordre : cache local (rapide) → puis Firestore (à jour)

  Future<void> _loadSettings() async {
    isLoading.value = true;

    try {
      // 1. D'abord : lire le cache local (SharedPreferences)
      await _loadFromCache();

      // 2. Ensuite : lire Firestore (écrase le cache si dispo)
      await _loadFromFirestore();
    } catch (e) {
      lastError = 'Erreur chargement : $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Cache local (SharedPreferences)
  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();

    newReportAlerts.value = prefs.getBool('newReportAlerts') ?? true;
    highConfirmAlerts.value = prefs.getBool('highConfirmAlerts') ?? true;
    weeklyDigest.value = prefs.getBool('weeklyDigest') ?? false;
    arabicLanguage.value = prefs.getBool('arabicLanguage') ?? true;
    frenchTranslation.value = prefs.getBool('frenchTranslation') ?? true;
  }

  // Firestore
  Future<void> _loadFromFirestore() async {
    final snap = await _settingsDoc.get();

    if (!snap.exists) return; // pas encore de document → on garde le cache

    final data = snap.data() as Map<String, dynamic>;

    newReportAlerts.value = data['newReportAlerts'] ?? newReportAlerts.value;
    highConfirmAlerts.value =
        data['highConfirmAlerts'] ?? highConfirmAlerts.value;
    weeklyDigest.value = data['weeklyDigest'] ?? weeklyDigest.value;
    arabicLanguage.value = data['arabicLanguage'] ?? arabicLanguage.value;
    frenchTranslation.value =
        data['frenchTranslation'] ?? frenchTranslation.value;

    // Met à jour le cache avec les dernières valeurs Firestore
    await _saveToCache();
  }

  //  SAUVEGARDER (bouton "Save Changes")

  Future<void> saveSettings() async {
    isSaving.value = true;
    lastError = null;

    try {
      final data = {
        'newReportAlerts': newReportAlerts.value,
        'highConfirmAlerts': highConfirmAlerts.value,
        'weeklyDigest': weeklyDigest.value,
        'arabicLanguage': arabicLanguage.value,
        'frenchTranslation': frenchTranslation.value,
        'updatedAt': FieldValue.serverTimestamp(), // date de màj
        'updatedBy': _adminId,
      };

      // Firestore : merge:true = pas d'écrasement des autres champs
      await _settingsDoc.set(data, SetOptions(merge: true));

      // Cache local : sauvegarde aussi
      await _saveToCache();

      // Snackbar succès
      Get.snackbar(
        'Paramètres sauvegardés',
        'Les modifications ont été enregistrées.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      lastError = e.toString();
      Get.snackbar(
        'Erreur',
        'Impossible de sauvegarder : $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  // Sauvegarde dans le cache local
  Future<void> _saveToCache() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('newReportAlerts', newReportAlerts.value);
    await prefs.setBool('highConfirmAlerts', highConfirmAlerts.value);
    await prefs.setBool('weeklyDigest', weeklyDigest.value);
    await prefs.setBool('arabicLanguage', arabicLanguage.value);
    await prefs.setBool('frenchTranslation', frenchTranslation.value);
  }
}
