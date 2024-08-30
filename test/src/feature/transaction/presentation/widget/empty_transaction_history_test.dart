import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/transaction/presentation/widget/empty_transaction_history.dart';

void main() {
  late Widget widget;

  setUp(
    () {
      widget = const MaterialApp(home: EmptyTransactionHistory());
    },
  );

  group('EmptyTransactionHistory Widget', () {
    testWidgets(
      "Check widgets",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);

        /// Assert Initial widgets
        expect(find.byIcon(Icons.history), findsOneWidget);
        expect(
          find.text(
            AppLocalizations.transactionHistoryEmpty.tr(),
          ),
          findsOneWidget,
        );
      },
    );
  });
}
