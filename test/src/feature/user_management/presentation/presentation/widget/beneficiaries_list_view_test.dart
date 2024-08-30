import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/provider/user_management_provider.dart';
import 'package:uae_top_up/src/feature/user_top_up/presentation/widget/beneficiaries_list_view.dart';
import 'package:uae_top_up/src/feature/user_top_up/presentation/widget/beneficiary_item.dart';

import '../../../../../../test_helpers.dart';
import '../../provider/user_management_provider_test.mocks.dart';

void main() {
  late Widget widget;
  late UserManagementProvider userProvider;
  late MockUserActions actions;

  setUp(
    () {
      actions = MockUserActions();
      userProvider = UserManagementProvider(
        MockUserManagementRepository(),
        MockTransactionChecks(),
        actions,
      );
      userProvider.user = createTestUser();
      widget = MaterialApp(
        home: ChangeNotifierProvider<UserManagementProvider>(
          create: (BuildContext context) => userProvider,
          builder: (context, userProvider) {
            return const Material(child: BeneficiariesListView());
          },
        ),
      );
    },
  );

  group('Beneficiary list Widget', () {
    testWidgets(
      "Empty list widget",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        expect(find.byType(SizedBox), findsOneWidget);
      },
    );

    testWidgets(
      "one item list widget",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        userProvider.user = createTestUser(
          beneficiaries: [createTestBeneficiary()],
        );
        userProvider.notifyListeners();
        await widgetTester.pump();
        expect(find.byType(BeneficiaryItem), findsOneWidget);
      },
    );

    testWidgets(
      "show transaction sheet",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        userProvider.user = createTestUser(
          beneficiaries: [createTestBeneficiary()],
        );
        userProvider.notifyListeners();
        await widgetTester.pump();
        final button = find.byType(ActionButton);

        await widgetTester.tap(button);
        await widgetTester.pumpAndSettle();
        verify(actions.showTransactionSheet(any, any)).called(1);
      },
    );
  });
}
