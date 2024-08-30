import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/feature/transaction/presentation/widget/empty_transaction_history.dart';
import 'package:uae_top_up/src/feature/transaction/presentation/widget/transaction_history_item.dart';
import 'package:uae_top_up/src/feature/transaction/presentation/widget/transaction_history_list.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';

import '../../../../../test_helpers.dart';
import '../../../user_management/presentation/provider/user_management_provider_test.mocks.dart';

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
            return const TransactionHistoryList();
          },
        ),
      );
    },
  );

  group('Transaction history list Widget', () {
    testWidgets(
      "Empty list widget",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        expect(find.byType(EmptyTransactionHistory), findsOneWidget);
      },
    );

    testWidgets(
      "Add transaction to state",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);

        userProvider.user = createTestUser(
          transactions: [createTestTransaction()],
        );
        userProvider.notifyListeners();
        await widgetTester.pump();

        expect(find.byType(EmptyTransactionHistory), findsNothing);
        expect(find.byType(TransactionHistoryItem), findsOneWidget);
      },
    );
  });
}
