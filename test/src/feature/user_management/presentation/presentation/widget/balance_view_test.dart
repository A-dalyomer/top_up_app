import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';
import 'package:uae_top_up/src/feature/user_top_up/presentation/widget/balance_view.dart';

import '../../../../../../test_helpers.dart';
import '../../provider/user_management_provider_test.mocks.dart';

void main() {
  late Widget widget;
  late UserManagementProvider userProvider;

  setUp(
    () {
      userProvider = UserManagementProvider(
        MockUserManagementRepository(),
        MockTransactionChecks(),
        MockUserActions(),
      );
      userProvider.user = createTestUser();
      widget = MaterialApp(
        home: ChangeNotifierProvider<UserManagementProvider>(
          create: (BuildContext context) => userProvider,
          builder: (context, userProvider) {
            return const BalanceView();
          },
        ),
      );
    },
  );

  group('BalanceView Widget', () {
    testWidgets(
      "Check widgets",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        expect(find.byType(Text), findsOneWidget);

        final currentBalance = userProvider.user.balance.toStringAsFixed(0);
        final widgetText =
            "${AppLocalizations.userBalance.tr()}: $currentBalance";
        expect(find.text(widgetText), findsOneWidget);
      },
    );
    testWidgets(
      "Check state update with balance",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        final currentBalance = userProvider.user.balance;
        final currentBalanceFixed = currentBalance.toStringAsFixed(0);
        final String widgetText =
            "${AppLocalizations.userBalance.tr()}: $currentBalanceFixed";
        expect(find.text(widgetText), findsOneWidget);

        const newBalance = 10000.0;
        userProvider.debitUserBalance(-newBalance);
        await widgetTester.pumpAndSettle();

        final String updatedWidgetText = widgetText.replaceAll(
          currentBalanceFixed,
          (newBalance + currentBalance).toStringAsFixed(0),
        );
        expect(find.text(updatedWidgetText), findsOneWidget);
        expect(find.text(widgetText), findsNothing);
      },
    );
  });
}
