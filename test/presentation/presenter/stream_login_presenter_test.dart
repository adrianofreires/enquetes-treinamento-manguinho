import 'package:enquetes/domain/entities/account_entity.dart';
import 'package:enquetes/domain/helpers/domain_errors.dart';
import 'package:enquetes/domain/usecases/authentication.dart';
import 'package:enquetes/presentation/presenter/presenters.dart';
import 'package:enquetes/presentation/protocols/protocols.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationMock extends Mock implements Validation {}

class AuthenticationMock extends Mock implements Authentication {}

void main() {
  late StreamLoginPresenter sut;
  late ValidationMock validation;
  late String email;
  late String password;
  late AuthenticationMock authentication;

  PostExpectation mockValidationCall(String field) => when(validation.validate(field: field == null ? anyNamed('field') : field, value: anyNamed('value')));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field!).thenReturn(value!);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(params: AuthenticationParams(email: email, password: password)));

  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer((_) => AccountEntity(faker.guid.guid()));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    authentication = AuthenticationMock();
    validation = ValidationMock();
    sut = StreamLoginPresenter(validation: validation, authentication: authentication);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
    mockAuthentication();
  });
  test('Should call Validation with correct email', () {
    sut.validateEmail(email);
    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test(
    'should emit email error if validation fails',
    () {
      // arrange
      mockValidation(value: 'error');

      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, 'false')));

      expectLater(sut.emailErrorStream, emitsInOrder(['error']));
      // act
      sut.validateEmail(email);
      sut.validateEmail(email);
      // assert
    },
  );

  test(
    'should emit null error if validation succeeds',
    () {
      // arrange
      mockValidation(value: 'error');

      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, 'false')));

      expectLater(sut.emailErrorStream, emitsInOrder(['error']));
      // act
      sut.validateEmail(email);
      sut.validateEmail(email);
      // assert
    },
  );

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);
    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test(
    'should emit password error if validation fails',
    () {
      // arrange
      mockValidation(value: 'error');

      sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, 'false')));

      expectLater(sut.emailErrorStream, emitsInOrder(['error']));
      // act
      sut.validatePassword(password);
      sut.validatePassword(password);
      // assert
    },
  );

  test(
    'should emit password error if validation fails',
    () {
      mockValidation(field: 'email', value: 'error');
      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, 'error')));
      sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, 'false')));
      // act
      sut.validateEmail(email);
      sut.validatePassword(password);
      // assert
    },
  );
  test(
    'should emit password error if validation fails',
    () async {
      mockValidation(field: 'email', value: 'error');
      sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, true)));
      expectLater(sut.isFormValidStream, emitsInOrder([false, true]));
      // act
      sut.validateEmail(email);
      await Future.delayed(Duration.zero);
      sut.validatePassword(password);
      // assert
    },
  );

  test(
    'should call authentication with correct values',
    () async {
      // act
      sut.validateEmail(email);
      sut.validatePassword(password);

      await sut.auth();
      // assert
      verify(authentication.auth(params: AuthenticationParams(email: email, password: password))).called(1);
    },
  );

  test(
    'should emit correct events on Authentication success',
    () async {
      // act
      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.auth();
    },
  );

  test(
    'should emit correct events on InvalidCredentialsError',
    () async {
      // act
      mockAuthenticationError(DomainError.invalidCredentials);
      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emits(false));
      sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Credenciais inválidas')));

      await sut.auth();
    },
  );

  test(
    'should emit correct events on UnexpectedError',
    () async {
      // act
      mockAuthenticationError(DomainError.invalidCredentials);
      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emits(false));
      sut.mainErrorStream.listen(expectAsync1((error) => expect(error, 'Algo errado aconteceu. Tente novamente em breve')));

      await sut.auth();
    },
  );

  test(
    'should not emit after dispose',
    () async {
      expectLater(sut.emailErrorStream, neverEmits(null));

      sut.dispose();
      sut.validateEmail(email);
    },
  );
}
