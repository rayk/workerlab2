import 'package:flutter_test/flutter_test.dart';
import 'package:workerlab/factorial.dart';

void main() {
  group('Factorial', () {
    final service = FactorialService();

    test('Should calculate factor.', () {
      final result = service.calc(15);
      print(result);
    });
  });
}
