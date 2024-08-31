import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uae_top_up/src/core/widget/api_action_button.dart';
import 'package:uae_top_up/src/core/widget/phone_number_field.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';
import 'package:uae_top_up/src/feature/user_management/data/model/beneficiary_model.dart';
import 'package:uae_top_up/src/feature/user_management/domain/entity/beneficiary.dart';
import 'package:uae_top_up/src/feature/user_management/presentation/widget/add_beneficiary_sheet.dart';

import '../../../../../../test_helpers.dart';

void main() {
  late Widget widget;
  Beneficiary? savedBeneficiary;
  bool returnValue = false;
  bool widgetRestModeEnabled = false;

  const String beneficiaryName = 'test name';

  /// Phone number field bug not accepting text in widget tests
  const String beneficiaryPhoneNumber = '';
  final Beneficiary newBeneficiary = createTestBeneficiary(
    name: beneficiaryName,
    phoneNumber: beneficiaryPhoneNumber,
  );

  final actionButton = find.byType(ApiActionButton);
  final phoneNumberField = find.byType(PhoneNumberField);
  final nameField = find.byWidgetPredicate(
    (widget) =>
        widget is TextField &&
        widget.decoration?.hintText == AppLocalizations.beneficiaryName.tr(),
  );

  void assignWidget() {
    widget = MaterialApp(
      home: Material(
        child: AddBeneficiarySheet(
          testMode: widgetRestModeEnabled,
          onSave: (p0) async {
            if (returnValue) {
              savedBeneficiary = p0;
            }
            return returnValue;
          },
        ),
      ),
    );
  }

  Future<void> enterTextAndSubmit(
    WidgetTester widgetTester, {
    int nameMultiplier = 1,
  }) async {
    await widgetTester.enterText(nameField, beneficiaryName * nameMultiplier);
    await widgetTester.enterText(phoneNumberField, beneficiaryPhoneNumber);

    await widgetTester.tap(actionButton);
    await widgetTester.pumpAndSettle();
  }

  setUp(
    () {
      savedBeneficiary = null;
      assignWidget();
    },
  );

  group('Add Beneficiary sheet Widget', () {
    testWidgets(
      "Enter name more than 20 chars",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);

        await enterTextAndSubmit(widgetTester, nameMultiplier: 4);

        expect(find.text(AppLocalizations.longName.tr()), findsOneWidget);
      },
    );
    testWidgets(
      "Enter name empty",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);

        await widgetTester.tap(actionButton);
        await widgetTester.pump();

        expect(find.text(AppLocalizations.fieldRequired.tr()), findsOneWidget);
      },
    );
    testWidgets(
      "Enter name normal",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);

        await enterTextAndSubmit(widgetTester);

        expect(find.text(AppLocalizations.longName.tr()), findsNothing);
        expect(find.text(AppLocalizations.fieldRequired.tr()), findsNothing);
      },
    );

    testWidgets(
      "Save beneficiary success",
      (widgetTester) async {
        widgetRestModeEnabled = true;
        returnValue = true;
        assignWidget();
        await widgetTester.pumpWidget(widget);

        await enterTextAndSubmit(widgetTester);

        expect(BeneficiaryModel.fromEntity(savedBeneficiary!), newBeneficiary);
      },
    );

    testWidgets(
      "Save beneficiary fails",
      (widgetTester) async {
        widgetRestModeEnabled = true;
        returnValue = false;
        assignWidget();
        await widgetTester.pumpWidget(widget);

        await enterTextAndSubmit(widgetTester);

        expect(savedBeneficiary, isNull);
      },
    );
  });
}
