import 'dart:async';

import 'package:squadron/squadron.dart';

abstract class PrimeInterface {
  FutureOr<bool> isPrime(int n);

  FutureOr<List<int>> getPrimeBatch(int count);

  FutureOr<Stream<int>> streamOfPrimes(int count);
}

class PrimeService implements PrimeInterface, WorkerService {
  @override
  Future<List<int>> getPrimeBatch(int count) {
    final cmp = Completer<List<int>>();
    var found = 0;
    var candidate = 0;
    final results = <int>[];

    while (found < count) {
      candidate++;
      if (isPrime(candidate)) {
        found++;
        results.add(candidate);
      }
    }

    cmp.complete(results);

    return cmp.future;
  }

  @override
  bool isPrime(int n) {
    if (n < 2) {
      return false;
    }

    for (int i = 2; i < n; i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  @override
  Stream<int> streamOfPrimes(int count) async* {
    var found = 0;
    var candidate = 0;
    while (found < count) {
      candidate++;
      if (isPrime(candidate)) {
        found++;
        yield candidate;
      }
    }
  }

  static const primeBatch = 1;
  static const primeCheck = 2;
  static const primeStream = 3;

  Map<int, CommandHandler> get operations => {
        primeBatch: (WorkerRequest req) => getPrimeBatch(req.args[0]),
        primeCheck: (WorkerRequest req) => isPrime(req.args[0]),
        primeStream: (WorkerRequest req) => streamOfPrimes(req.args[0]),
      };
}
