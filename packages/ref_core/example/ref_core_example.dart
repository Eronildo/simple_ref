import 'dart:developer';

import 'package:ref_core/ref_core.dart';

void main() {
  // Create a reference of [Something]
  final refSomething = Ref(Something.new);

  // Get a instance of [Something] reference
  final something = refSomething();

  // Show a log debug mode of instance of [Something]
  log('$something');
}

// Something class wrapped with [Ref] in main
class Something {
  @override
  String toString() {
    return 'Instance of Something';
  }
}
