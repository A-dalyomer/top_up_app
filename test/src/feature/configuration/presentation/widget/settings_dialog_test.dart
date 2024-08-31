import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/feature/configuration/domain/util/app_themes.dart';
import 'package:uae_top_up/src/feature/configuration/presentation/provider/settings_provider.dart';
import 'package:uae_top_up/src/feature/configuration/presentation/widget/settings_dialog.dart';
import 'package:uae_top_up/src/feature/local_storage/data/repository/local_storage_repository_impl.dart';
import 'package:uae_top_up/src/feature/localization/domain/constants/const_locales.dart';
import 'package:uae_top_up/src/feature/user_management/domain/repository/user_management_repository.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/transaction_checks.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/user_actions.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';

import 'settings_dialog_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserManagementRepository>(),
  MockSpec<UserActions>(),
  MockSpec<TransactionChecks>(),
])
void main() {
  late Widget widget;
  late UserManagementProvider userProvider;
  late MockUserManagementRepository userManagementRepository;
  late SettingsProvider settingsProvider;

  setUp(
    () async {
      userManagementRepository = MockUserManagementRepository();
      userProvider = UserManagementProvider(
        userManagementRepository,
        MockTransactionChecks(),
        MockUserActions(),
      );

      widget = MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) {
                settingsProvider = SettingsProvider(
                  context,
                  localStorage: LocalStorageRepositoryImpl(
                    storageClient: const FlutterSecureStorage(),
                  ),
                );
                return settingsProvider;
              },
              lazy: false,
            ),
            ChangeNotifierProvider(
              create: (BuildContext context) => userProvider,
              lazy: false,
            ),
          ],
          builder: (context, child) {
            return Builder(builder: (context) {
              return MaterialApp(
                locale: ConstLocales.english,
                themeMode: context.read<SettingsProvider>().appThemeMode,
                theme: AppThemes().light(),
                home: const SettingsDialog(testMode: true),
              );
            });
          });
    },
  );

  group('settings dialog Widget', () {
    testWidgets(
      "Test change theme mode",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        final themeButton = find.byType(Switch);

        await widgetTester.tap(themeButton);
        await widgetTester.pumpAndSettle();

        expect(settingsProvider.appThemeMode, ThemeMode.dark);
      },
    );
    testWidgets(
      "Test change locale",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        final localeButton = find.text(
          ConstLocales.english.languageCode.toUpperCase(),
        );

        await widgetTester.tap(localeButton);
        await widgetTester.pumpAndSettle();
      },
    );

    testWidgets(
      "Test sign out user",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        final localeButton = find.byIcon(Icons.logout);
        when(userManagementRepository.removeUser()).thenAnswer((_) async {});

        await widgetTester.tap(localeButton);
        await widgetTester.pumpAndSettle();

        expect(userProvider.userExists, isFalse);
      },
    );
  });
}
