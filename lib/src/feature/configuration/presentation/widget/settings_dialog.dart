import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/extension/size_extensions.dart';
import 'package:uae_top_up/src/feature/configuration/presentation/provider/settings_provider.dart';
import 'package:uae_top_up/src/feature/localization/domain/constants/const_locales.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';

import '../../../user_management/presentation/provider/user_management_provider.dart';
import '../../../configuration/presentation/widget/settings_item.dart';

/// App settings dialog
/// Contains settings for theme mode, language and sign out user
class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key, this.testMode = false});

  /// Used for unit tests as a workaround using the context.locale
  final bool testMode;

  /// Change active locale with the passed [locale]
  void changeLanguage(BuildContext context, Locale locale) {
    context.setLocale(locale);
  }

  /// Closes the dialog and sign out the current user from user provider of context
  void signOut(BuildContext context) {
    Navigator.pop(context);
    context.read<UserManagementProvider>().signOutUser();
  }

  /// Toggle app active theme mode from [settingsProvider]
  toggleTheme(SettingsProvider settingsProvider) =>
      settingsProvider.toggleDarkMode();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 0.8.width(context)),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 26),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<SettingsProvider>(
                      builder: (context, settingsProvider, chile) {
                    return SettingsItem(
                      title: AppLocalizations.darkMode.tr(),
                      trailing: Switch(
                        value: settingsProvider.appThemeMode == ThemeMode.dark,
                        onChanged: (value) => toggleTheme(settingsProvider),
                      ),
                      onTap: () => toggleTheme(settingsProvider),
                    );
                  }),
                  const Divider(),
                  SettingsItem(
                    title: AppLocalizations.appLanguage.tr(),
                    trailing: SegmentedButton<Locale>(
                      segments: [
                        ButtonSegment(
                          value: ConstLocales.english,
                          label: Text(
                            ConstLocales.english.languageCode.toUpperCase(),
                          ),
                        ),
                        ButtonSegment(
                          value: ConstLocales.arabic,
                          label: Text(
                            ConstLocales.arabic.languageCode.toUpperCase(),
                          ),
                        ),
                      ],
                      selected: {
                        testMode ? ConstLocales.english : context.locale
                      },
                      onSelectionChanged: (locale) => changeLanguage(
                        context,
                        locale.first,
                      ),
                    ),
                  ),
                  const Divider(),
                  SettingsItem(
                    title: AppLocalizations.signOut.tr(),
                    trailing: const Icon(Icons.logout),
                    onTap: () => signOut(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
