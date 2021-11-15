import 'package:flutter/material.dart';
import 'package:squadron/squadron_pool.dart';
import 'package:workerlab/prime_service.dart';
import 'package:workerlab/prime_worker.dart';

import 'prime_service_vm.dart' as prime_isolate;

void main() async {
  runApp(MyApp(
      pool: WorkerPool<PrimeWorker>(
    () => PrimeWorker(prime_isolate.start),
    maxWorkers: 8,
    minWorkers: 2,
    maxParallel: 1,
  )));
}

class MyApp extends StatelessWidget {
  final WorkerPool<PrimeWorker> pool;
  const MyApp({Key? key, required this.pool}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        pool: pool,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final WorkerPool<PrimeWorker> pool;

  const MyHomePage({
    Key? key,
    required this.title,
    required this.pool,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int fact = 0;
  List<int> primes = [];
  late Duration elapsedOnWorker = Duration.zero;
  late Duration elapsedOnMain = Duration.zero;
  List<int> workerPrimes = [];

  List<int> directPrimes = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _calculateWorker() {
    final sw = Stopwatch()..start();
    widget.pool
        .compute((worker) => worker.getPrimeBatch(10000))
        .then((List<int> results) {
      sw.stop();
      elapsedOnWorker = sw.elapsed;
      setState(() {
        primes = results;
      });
    });
  }

  void _calculateDirect() {
    final sw = Stopwatch()..start();
    final cal = PrimeService();
    cal.getPrimeBatch(10000).then((List<int> results) {
      sw.stop();
      elapsedOnMain = sw.elapsed;
      setState(() {
        directPrimes = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(primes.length.toString()),
            ),
            Text(
                'Primes From Worker: ${elapsedOnWorker.inMilliseconds.toString()} ms'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () => _calculateWorker(),
                  child: const Text('Generate Primes (On Worker)')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(directPrimes.length.toString()),
            ),
            Text(
                'Primes On Direct: ${elapsedOnMain.inMilliseconds.toString()} ms'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () => _calculateDirect(),
                child: const Text('Generate Primes (Direct)'),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
