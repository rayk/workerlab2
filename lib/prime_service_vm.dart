import 'package:squadron/squadron.dart';

import 'prime_service.dart';

void start(Map command) {
  run((startRequest) => PrimeService(), command);
}
