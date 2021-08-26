import '../../domain/helpers/errors.dart';

import '../../domain/usecases/authentication.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;
  Future<void> auth(AuthenticationParams params) async {
    try {
      await httpClient.request(
          url: url,
          method: 'post',
          body: RemoteAuthenticationParams.fromDomain(params).toJson());
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }

  RemoteAuthentication({required this.httpClient, required this.url});
}

class RemoteAuthenticationParams {
  final String email, password;
  RemoteAuthenticationParams({required this.email, required this.password});
  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(
          email: params.email, password: params.password);
  Map toJson() => {'email': email, 'password': password};
}
