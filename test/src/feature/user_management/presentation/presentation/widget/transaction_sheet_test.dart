import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uae_top_up/src/core/constants/const_configs.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/widget/transaction_sheet.dart';

import '../../../../../../test_helpers.dart';

void main() {
  late Widget widget;
  late Beneficiary testBeneficiary;
  double selectedAmount = 0;
  bool returnValue = false;
  late List<int> transactionOptions;

  setUp(
    () {
      transactionOptions = ConstConfigs.transactionOptions;
      testBeneficiary = createTestBeneficiary();
      widget = MaterialApp(
        home: Material(
          child: TransactionSheet(
            beneficiary: testBeneficiary,
            onRechargePress: (p0) {
              selectedAmount = p0;
              return returnValue;
            },
          ),
        ),
      );
    },
  );

  group('Transaction sheet Widget', () {
    testWidgets(
      "Check transactions visible",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        final int testedTransaction = transactionOptions.last;
        final listTileButton = find.text("$testedTransaction AED");
        await widgetTester.scrollUntilVisible(listTileButton, 100);
      },
    );
    testWidgets(
      "Check select transaction and success save",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        final int testedTransaction = transactionOptions[1];
        final listTileButton = find.text("$testedTransaction AED");
        final rechargeButton = find.byType(ActionButton);
        final errorIcon = find.byIcon(Icons.error);
        returnValue = true;

        await widgetTester.tap(listTileButton);
        await widgetTester.pump();

        await widgetTester.tap(rechargeButton);
        await widgetTester.pump();

        expect(selectedAmount, testedTransaction);
        expect(errorIcon, findsNothing);
      },
    );
    testWidgets(
      "Check select transaction and fail save then retry",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);
        final int firstTransaction = transactionOptions.first;
        final int testedTransaction = transactionOptions[1];
        final firstListTileButton = find.text("$firstTransaction AED");
        final listTileButton = find.text("$testedTransaction AED");
        final rechargeButton = find.byType(ActionButton);
        final errorIcon = find.byIcon(Icons.error);
        returnValue = false;

        await widgetTester.tap(listTileButton);
        await widgetTester.pump();

        await widgetTester.tap(rechargeButton);
        await widgetTester.pump();

        expect(selectedAmount, testedTransaction);
        expect(errorIcon, findsOneWidget);

        await widgetTester.tap(firstListTileButton);
        await widgetTester.pump();
      },
    );
  });
}
