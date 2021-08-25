import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth({required String email, required String password});
}

class AuthenticationParams {
  final String email, password;
  AuthenticationParams({required this.email, required this.password});
}
