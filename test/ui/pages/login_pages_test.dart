import 'dart:async';

import 'package:enquetes/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterMock extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter presenter;
  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErrorController;
  late StreamController<bool?> isFormValidController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterMock();
    emailErrorController = StreamController<String?>();
    passwordErrorController = StreamController<String?>();
    isFormValidController = StreamController<bool?>();
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    final loginPage = MaterialApp(
      home: LoginPage(presenter),
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
  });

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('E-mail'), matching: find.byType(Text));

    expect(emailTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the hint text');

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));

    expect(passwordTextChildren, findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the hint text');

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call validate with corrects values',
      (WidgetTester tester) async {
    await loadPage(tester);
    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('E-mail'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));
  });

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);
    emailErrorController.add('any Error');
    await tester.pump();
    expect(find.text('any Error'), findsOneWidget);
  });

  testWidgets('Should present no error if email is valid',
      (WidgetTester tester) async {
    await loadPage(tester);
    emailErrorController.add(null);
    await tester.pump();
    expect(
      find.descendant(
          of: find.bySemanticsLabel('E-mail'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });
  testWidgets('Should present no error if email is valid',
      (WidgetTester tester) async {
    await loadPage(tester);
    emailErrorController.add('');
    await tester.pump();
    expect(
      find.descendant(
          of: find.bySemanticsLabel('E-mail'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should present error if password is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);
    passwordErrorController.add('any Error');
    await tester.pump();
    expect(find.text('any Error'), findsOneWidget);
  });

  testWidgets('Should present no error if password is valid',
      (WidgetTester tester) async {
    await loadPage(tester);
    passwordErrorController.add(null);
    await tester.pump();
    expect(
      find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });
  testWidgets('Should present no error if password is valid',
      (WidgetTester tester) async {
    await loadPage(tester);
    passwordErrorController.add('');
    await tester.pump();
    expect(
      find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('Should enable button if form is Valid',
      (WidgetTester tester) async {
    await loadPage(tester);
    isFormValidController.add(true);
    await tester.pump();
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should enable button if form is Valid',
      (WidgetTester tester) async {
    await loadPage(tester);
    isFormValidController.add(false);
    await tester.pump();
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });
}