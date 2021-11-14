import 'package:squadron/squadron.dart';
import 'package:workerlab/prime_service.dart';

class PrimeWorker extends Worker implements PrimeInterface {
  PrimeWorker(entryPoint, {String? id, List args = const []})
      : super(entryPoint, id: id, args: args);

  @override
  Future<List<int>> getPrimeBatch(int count) =>
      send(PrimeService.primeBatch, [count]);

  @override
  Future<bool> isPrime(int n) => send(PrimeService.primeCheck, [n]);

  Map<int, CommandHandler> get operations => const {};

  @override
  Future<Stream<int>> streamOfPrimes(int count) =>
      send(PrimeService.primeStream, [count]);
}
