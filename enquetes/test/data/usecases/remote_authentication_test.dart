import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:enquetes/domain/usecases/authentication.dart';
import 'package:enquetes/domain/helpers/errors.dart';
import 'package:enquetes/data/http/http.dart';
import 'package:enquetes/data/usecases/usecases.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {
  late HttpClientMock httpClient;
  late String url;
  late RemoteAuthentication sut;
  late AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientMock();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
  });

  test('Should call HttpClient with correct values', () async {
    
    await sut.auth(params);
    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {'email': params.email, 'password': params.password},
    ));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

    test('Should throw UnexpectedError if HttpClient returns 404', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.notFound);
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

    test('Should throw UnexpectedError if HttpClient returns 500', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.serverError);
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

    test('Should throw InvalidCredencialError if HttpClient returns 401', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.unauthorized);
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });
}
