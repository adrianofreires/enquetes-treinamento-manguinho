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

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field!).thenReturn(value!);
  }

  setUp(() {
    validation = ValidationMock();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
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

      expectLater(sut.emailErrorStream, emits('error'));
      // act
      sut.validateEmail(email);
      // assert
    },
  );
}
