import 'package:flutter/material.dart';
import 'package:uae_top_up/src/feature/local_storage/data/constants/const_storage_keys.dart';
import 'package:uae_top_up/src/feature/local_storage/domain/repository/local_storage_repository.dart';

/// Responsible for managing the app theme settings
class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this.context, {required this.localStorage}) {
    loadThemeMode();
  }

  /// App Build context
  final BuildContext context;

  /// Local storage instance to save and load theme mode info
  final LocalStorageRepository localStorage;

  /// Active theme mode state
  ThemeMode appThemeMode = ThemeMode.light;

  /// Toggles the [appThemeMode] state and saves the new state
  void toggleDarkMode() {
    if (appThemeMode == ThemeMode.light) {
      appThemeMode = ThemeMode.dark;
    } else {
      appThemeMode = ThemeMode.light;
    }
    notifyListeners();
    saveActiveThemeState(appThemeMode);
  }

  /// Provider initializer
  void loadThemeMode() async {
    appThemeMode = await getCurrentSavedTheme();
    notifyListeners();
  }

  /// Save the [appliedTheme] to local storage
  Future<void> saveActiveThemeState(ThemeMode appliedTheme) async {
    await localStorage.writeValue(
      ConstStorageKeys.savedThemeMode,
      appliedTheme.index.toString(),
    );
  }

  /// Load the saved theme mode from local storage
  Future<ThemeMode> getCurrentSavedTheme() async {
    final String themeIndexString =
        await localStorage.readValue(ConstStorageKeys.savedThemeMode) ?? '1';
    return ThemeMode.values[int.parse(themeIndexString)];
  }
}
