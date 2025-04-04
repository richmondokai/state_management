// test/controllers/form_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_assessment3/controllers/form_controller.dart';

void main() {
  group('FormController Tests', () {
    late FormController controller;
    late bool submissionCalled;

    setUp(() {
      submissionCalled = false;
      controller = FormController(
        values: {'email': '', 'password': ''},
        validate: (values) {
          final errors = <String, String>{};
          if (values['email']?.isEmpty ?? true) {
            errors['email'] = 'Required';
          }
          if (values['password']?.isEmpty ?? true) {
            errors['password'] = 'Required';
          }
          return errors;
        },
      );
    });

    test('Initial values are empty', () {
      expect(controller.values['email'], '');
      expect(controller.values['password'], '');
    });

    test('Validation shows errors for empty fields', () {
      controller.setValue('email', '');
      expect(controller.errors['email'], 'Required');
    });

    test('Successful submission', () async {
      controller.setValue('email', 'test@example.com');
      controller.setValue('password', 'password123');

      await controller.submit((_) async {
        submissionCalled = true;
      });

      expect(submissionCalled, true);
    });

    test('No submission when validation fails', () async {
      bool didSubmit = false;
      await controller.submit((_) async {
        didSubmit = true;
      });

      expect(didSubmit, false);
    });

    test('isSubmitting state changes correctly', () async {
      controller.setValue('email', 'test@example.com');
      controller.setValue('password', 'password123');

      final submissionFuture = controller.submit((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
      });

      expect(controller.isSubmitting, true);
      await submissionFuture;
      expect(controller.isSubmitting, false);
    });
  });
}
