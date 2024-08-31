import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/util/dependency_injection_manager.dart';
import 'package:uae_top_up/src/core/util/dialogs.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/core/widget/loading_indicator.dart';
import 'package:uae_top_up/src/feature/configuration/domain/entity/app_config.dart';
import 'package:uae_top_up/src/feature/configuration/domain/util/app_themes.dart';
import 'package:uae_top_up/src/feature/configuration/domain/util/core_config_manager.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/network/domain/repository/api_request_repository.dart';
import 'package:uae_top_up/src/feature/transaction/presentation/widget/transaction_history_item.dart';
import 'package:uae_top_up/src/feature/user_management/domain/repository/user_management_repository.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/transaction_checks.dart';
import 'package:uae_top_up/src/feature/user_management/domain/util/user_actions.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/widget/add_beneficiary_sheet.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/widget/transaction_sheet.dart';
import 'package:uae_top_up/src/feature/user_top_up/presentation/screen/home_screen.dart';
import 'package:uae_top_up/src/feature/user_top_up/presentation/widget/beneficiary_item.dart';

import '../../../../../test_helpers.dart';
import 'home_screen_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ApiRequestRepository>(),
  MockSpec<Dialogs>(),
  MockSpec<UserManagementRepository>(),
  MockSpec<TransactionChecks>(),
])
void main() {
  late Widget widget;
  late UserManagementProvider userProvider;
  late CoreConfigManager coreConfigManager;
  late UserActions userActions;
  late MockApiRequestRepository apiRequestRepository;
  late MockDialogs mockDialogs;

  setUp(
    () async {
      userActions = UserActions();
      userProvider = UserManagementProvider(
        MockUserManagementRepository(),
        MockTransactionChecks(),
        userActions,
      );
      apiRequestRepository = MockApiRequestRepository();
      mockDialogs = MockDialogs();
      userProvider.user = createTestUser();

      widget = MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) {
                coreConfigManager = CoreConfigManager(apiRequestRepository);
                return coreConfigManager;
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
              final AppConfig? appConfig = context.select(
                (CoreConfigManager value) => value.appConfig,
              );

              if (appConfig == null) return const LoadingIndicator();

              return MaterialApp(
                theme: AppThemes().light(),
                home: HomeScreen(
                  dialogs: mockDialogs,
                ),
              );
            });
          });
    },
  );

  Future<void> initConfig(WidgetTester widgetTester) async {
    coreConfigManager.initializeConfig();
    await widgetTester.pumpAndSettle();
  }

  group('Home screen Widget', () {
    testWidgets(
      "Test injections",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        await DIManager.initAppInjections();
      },
    );

    testWidgets(
      "Loading state",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        expect(find.byType(LoadingIndicator), findsOneWidget);
      },
    );
    testWidgets(
      "Done loading state",
      (widgetTester) async {
        final userNameText = find.text(userProvider.user.name);
        await widgetTester.pumpWidget(widget);

        coreConfigManager.initializeConfig();
        await widgetTester.pumpAndSettle();
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(userNameText, findsOneWidget);
      },
    );
    testWidgets(
      "Check update beneficiaries and transactions",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        await initConfig(widgetTester);
        userProvider.user = createTestUser(
          beneficiaries: [createTestBeneficiary()],
          transactions: [createTestTransaction()],
        );
        userProvider.notifyListeners();
        await widgetTester.pump();

        expect(find.byType(BeneficiaryItem), findsOneWidget);
        expect(
          find.byType(BeneficiaryItem).hitTestable(),
          findsOneWidget,
        );
        expect(find.byType(TransactionHistoryItem), findsOneWidget);
        expect(
          find.byType(TransactionHistoryItem).hitTestable(),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "Press settings button",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        await initConfig(widgetTester);
        final settings = find.byIcon(Icons.settings);

        await widgetTester.tap(settings);
        await widgetTester.pump();

        when(mockDialogs.showWidgetDialog(any, any)).thenReturn(() {});
      },
    );

    testWidgets(
      "Press Add beneficiary button",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        await initConfig(widgetTester);
        final addBeneficiarySheet = find.byType(AddBeneficiarySheet);
        final addBeneficiaryButton = find.byWidgetPredicate(
          (widget) =>
              widget is ActionButton &&
              widget.title == AppLocalizations.addBeneficiary.tr(),
        );

        await widgetTester.tap(addBeneficiaryButton);
        await widgetTester.pumpAndSettle();

        expect(addBeneficiarySheet, findsOneWidget);
      },
    );

    testWidgets(
      "Press Recharge button",
      (widgetTester) async {
        userProvider.user = createTestUser(
          beneficiaries: [
            createTestBeneficiary(),
          ],
        );
        userProvider.notifyListeners();
        await widgetTester.pump();

        await widgetTester.pumpWidget(widget);
        await initConfig(widgetTester);
        final transactionSheet = find.byType(TransactionSheet);
        final rechargeButton =
            find.text(AppLocalizations.rechargeNow.tr()).first;

        await widgetTester.tap(rechargeButton);
        await widgetTester.pumpAndSettle();

        expect(transactionSheet, findsOneWidget);
      },
    );
  });
}
