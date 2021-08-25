import '../../domain/usecases/authentication.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;
  Future<void>? auth(AuthenticationParams params) async {
    await httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAuthenticationParams.fromDomain(params).toJson());
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
