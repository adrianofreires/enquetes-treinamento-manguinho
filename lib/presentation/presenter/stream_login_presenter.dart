import 'dart:async';

import 'package:flutter/material.dart';

import '../protocols/protocols.dart';

class LoginState {
  late String email;
  late String password;
  late String emailError;
  late String passwordError;
  bool get isFormValid => emailError == null && passwordError == null && email != null && password != null;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get emailErrorStream => _controller.stream.map((state) => state.emailError).distinct(); //o distinct faz com que só emita o valor se ele for diferente do anterior

  Stream<String> get passwordErrorStream => _controller.stream.map((state) => state.passwordError).distinct();

  Stream<bool> get isFormValidStream => _controller.stream.map((state) => state.isFormValid).distinct();

  StreamLoginPresenter({required this.validation});

  void _update() => _controller.add(_state);

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = validation.validate(field: 'password', value: password);
    _update();
  }
}
