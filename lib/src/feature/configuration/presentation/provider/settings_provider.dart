import 'package:flutter/material.dart';
import 'package:uae_top_up/src/feature/local_storage/data/constants/const_storage_keys.dart';
import 'package:uae_top_up/src/feature/local_storage/domain/repository/local_storage_repository.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this.context, {required this.localStorage}) {
    loadThemeMode();
  }
  final BuildContext context;
  final LocalStorageRepository localStorage;

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
    await localStorage.writeValue(
      ConstStorageKeys.savedThemeMode,
      appliedTheme.index.toString(),
    );
  }

  Future<ThemeMode> getCurrentSavedTheme() async {
    final String themeIndexString =
        await localStorage.readValue(ConstStorageKeys.savedThemeMode) ?? '1';
    return ThemeMode.values[int.parse(themeIndexString)];
  }
}
