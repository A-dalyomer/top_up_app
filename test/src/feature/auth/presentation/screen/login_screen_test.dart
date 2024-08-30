import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uae_top_up/src/core/constants/const_widget_keys.dart';
import 'package:uae_top_up/src/core/widget/action_button.dart';
import 'package:uae_top_up/src/core/widget/loading_indicator.dart';
import 'package:uae_top_up/src/feature/auth/presentation/provider/login_provider.dart';
import 'package:uae_top_up/src/feature/auth/presentation/screen/login_screen.dart';
import 'package:uae_top_up/src/feature/auth/presentation/widget/login_form.dart';
import 'package:uae_top_up/src/feature/auth/presentation/widget/login_screen_header.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';

import '../../../../../test_helpers.dart';

void main() {
  late LoginProvider loginProvider;
  late Widget widget;

  setUp(
    () {
      loginProvider = LoginProvider(
        loginUser: (phoneNumber, password) async {},
      );
      widget = MaterialApp(
        home: LoginScreen(loginProvider: loginProvider),
      );
    },
  );

  group('TransactionRepositoryImpl', () {
    testWidgets(
      "All Screen components",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);

        final loginButton = find.byType(ActionButton);

        /// Assert Initial widgets
        expect(find.byType(LoginScreenHeader), findsOneWidget);
        expect(find.byType(LoginForm), findsOneWidget);
        expect(find.byType(LoadingIndicator), findsNothing);
        expect(loginButton, findsOneWidget);
      },
    );

    testWidgets(
      "Trigger forms validation",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);

        /// Try login with no valid input
        await widgetTester.tap(find.byType(ActionButton));
        await widgetTester.pump();

        /// Field validation
        final phoneNumberField = find.byKey(ConstWidgetKeys.phoneFormField);
        final passwordField = find.byKey(ConstWidgetKeys.passwordFormField);

        expect(phoneNumberField, findsOneWidget);
        expect(passwordField, findsOneWidget);
        expect(find.text(AppLocalizations.passwordHint.tr()), findsOneWidget);
        expect(find.byType(LoadingIndicator), findsNothing);
      },
    );

    testWidgets(
      "Test loading states",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);

        loginProvider.setLoadingState(true);
        await widgetTester.pump();
        expect(loginProvider.loading, isTrue);
        expect(find.byType(LoadingIndicator), findsOneWidget);

        loginProvider.setLoadingState(false);
        await widgetTester.pump();
        expect(loginProvider.loading, isFalse);
        expect(find.byType(LoadingIndicator), findsNothing);
      },
    );

    testWidgets(
      "Test entering text to provider",
      (widgetTester) async {
        await widgetTester.pumpWidget(widget);

        /// enter login data to validate the form
        final passwordField = find.byKey(ConstWidgetKeys.passwordFormField);
        final String userPhoneNumber =
            createTestUser().phoneNumber.replaceAll("+971", "");
        const String userPassword = "12345678";

        /// International phone number input bug
        /// widget is not accepting enter text by tests
        loginProvider.setPhoneNumber(userPhoneNumber);
        await widgetTester.enterText(passwordField, userPassword);
        await widgetTester.pump();

        expect(loginProvider.phoneNumber, userPhoneNumber);
        expect(loginProvider.password, userPassword);
        expect(find.text(userPassword), findsOneWidget);

        await widgetTester.tap(find.byType(ActionButton));
        await widgetTester.pump();

        // stopped by validation due to phone number field test bug
        expect(find.byType(LoadingIndicator), findsNothing);
      },
    );
  });
}
