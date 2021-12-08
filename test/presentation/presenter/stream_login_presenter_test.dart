import 'package:enquetes/presentation/presenter/presenters.dart';
import 'package:enquetes/presentation/protocols/protocols.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ValidationMock extends Mock implements Validation {}

void main() {
  late StreamLoginPresenter sut;
  late ValidationMock validation;
  late String email;
  late String password;

  PostExpectation mockValidationCall(String field) => when(validation.validate(field: field == null ? anyNamed('field') : field, value: anyNamed('value')));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field!).thenReturn(value!);
  }

  setUp(() {
    validation = ValidationMock();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
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
      sut.validatePassword(email);
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
      sut.validatePassword(email);
      await Future.delayed(Duration.zero);
      sut.validatePassword(password);
      // assert
    },
  );
}
