import 'dart:isolate';

import 'package:squadron/squadron.dart';

import 'factorial.dart';

final workerPool = WorkerPool(() => createDeviceFactorialWorker(),
    maxWorkers: 4, maxParallel: 2);

FactorialWorker createDeviceFactorialWorker() => FactorialWorker(_main);

void _main(Map command) {
  final operations = <int, CommandHandler>{};

  final workerPort = ReceivePort();

  workerPort.listen((command) {
    final req = WorkerRequest.deserialize(command);
    req.terminate
        ? Isolate.current.kill(priority: Isolate.immediate)
        : Worker.process(operations, req);
  });

  final startRequest = WorkerRequest.deserialize(command);
  assert(startRequest.connect == true);

  Worker.connect(
    startRequest.client,
    workerPort,
    operations: operations,
    serviceOperations: FactorialService().operations,
  );
}
