import 'package:flutter_test/flutter_test.dart';
import 'package:workerlab/prime_service.dart';

void main() {
  group('Prime Service:', () {
    final sut = PrimeService();

    test('Should test if a number is prime.', () {
      expect(sut.isPrime(6), isFalse, reason: 'This is not a prime number');
      expect(sut.isPrime(5), isTrue, reason: '5 is a prime number.');
    });

    test('Should return a list of n primes.', () async {
      final results = await sut.getPrimeBatch(25);
      expect(results.length, equals(25));
      for (var n in results) {
        expect(sut.isPrime(n), isTrue);
      }
    });

    test('Should return a stream of primes.', () {
      sut.streamOfPrimes(5000).listen(expectAsync1((value) {
            expect(sut.isPrime(value), isTrue);
          }, count: 5000));
    });
  });
}
