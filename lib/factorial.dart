import 'dart:async';

import 'package:squadron/squadron.dart';

abstract class Calculator {
  FutureOr<int> calc(int n);
}

class FactorialService implements Calculator {
  @override
  int calc(int n) {
    var fact = 1;
    for (var i = 2; i <= n; i++) {
      fact *= i;
    }
    return fact;
  }

  static const calcFactorial = 1;

  Map<int, CommandHandler> get operations =>
      {calcFactorial: (WorkerRequest req) => calc(req.args[0])};
}

class FactorialWorker extends Worker implements Calculator {
  FactorialWorker(entryPoint, {String? id, List args = const []})
      : super(entryPoint, id: id, args: args);

  @override
  FutureOr<int> calc(int n) => send(FactorialService.calcFactorial, [n]);
}
