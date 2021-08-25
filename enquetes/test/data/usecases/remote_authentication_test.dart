
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:enquetes/domain/usecases/authentication.dart';
import 'package:enquetes/data/http/http.dart';
import 'package:enquetes/data/usecases/usecases.dart';





class HttpClientMock extends Mock implements HttpClient {}

void main() {
  late HttpClientMock httpClient;
  late String url;
  late RemoteAuthentication sut;

  setUp(() {
    httpClient = HttpClientMock();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    final params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
    await sut.auth(params);
    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    ));
  });
}
