import 'package:equatable/equatable.dart';

import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity?> auth({required AuthenticationParams params});
}

class AuthenticationParams extends Equatable {
  final String email, password;

  @override
  List get props => [email, password];

  AuthenticationParams({required this.email, required this.password});
}
