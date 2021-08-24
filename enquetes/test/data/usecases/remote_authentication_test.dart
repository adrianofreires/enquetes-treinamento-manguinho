import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;
  Future<void>? auth() async {
    await httpClient.request(url: url, method: 'post');
  }

  RemoteAuthentication({required this.httpClient, required this.url});
}

abstract class HttpClient {
  Future<void>? request({required String url, required String method});
}

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
    await sut.auth();
    verify(httpClient.request(url: url, method: 'post'));
  });
}
