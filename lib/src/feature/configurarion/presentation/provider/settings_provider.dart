import 'package:flutter/material.dart';
import 'package:uae_top_up/src/core/util/dependency_injection_manager.dart';
import 'package:uae_top_up/src/feature/local_storage/data/constants/const_storage_keys.dart';
import 'package:uae_top_up/src/feature/local_storage/domain/repository/local_storage_repository.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this.context) {
    loadThemeMode();
  }
  final BuildContext context;

  ThemeMode appThemeMode = ThemeMode.light;

  void toggleDarkMode() {
    if (appThemeMode == ThemeMode.light) {
      appThemeMode = ThemeMode.dark;
    } else {
      appThemeMode = ThemeMode.light;
    }
    notifyListeners();
    saveActiveThemeState(appThemeMode);
  }

  void loadThemeMode() async {
    appThemeMode = await getCurrentSavedTheme();
    notifyListeners();
  }

  Future<void> saveActiveThemeState(ThemeMode appliedTheme) async {
    final localeStorage = DIManager.getIt<LocalStorageRepository>();
    await localeStorage.writeValue(
      ConstStorageKeys.savedThemeMode,
      appliedTheme.index.toString(),
    );
  }

  Future<ThemeMode> getCurrentSavedTheme() async {
    final localeStorage = DIManager.getIt<LocalStorageRepository>();
    final String themeIndexString =
        await localeStorage.readValue(ConstStorageKeys.savedThemeMode) ?? '1';
    return ThemeMode.values[int.parse(themeIndexString)];
  }
}
