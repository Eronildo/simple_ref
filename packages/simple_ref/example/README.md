source code with tests: [examples/flutter_todos/lib/main.dart](https://github.com/Eronildo/simple_ref/tree/master/examples/flutter_todos/lib/main.dart)

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_ref/simple_ref.dart';

class Controller implements Disposable {
  late final _count = ValueNotifier(0);

  // we expose it as a readable value listenable
  // so it cannot be changed from outside the controller.
  ValueListenable<int> get count => _count;

  void increment() => _count.value++;
  void decrement() => _count.value--;

  @override
  void dispose() {
    _count.dispose();
  }
}

final countControllerRef = Ref.autoDispose((_) => Controller());

void main() {
  runApp(const RefScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple Ref Counter'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const Center(child: CounterText()),
        floatingActionButton: const Buttons(),
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = countControllerRef.of(context);
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: controller.count,
      builder: (_, __) {
        final count = controller.count.value;
        return Text('$count', style: theme.textTheme.displayLarge);
      },
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = countControllerRef(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: controller.increment,
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          onPressed: controller.decrement,
          child: const Icon(Icons.remove),
        ),
      ],
    );
  }
}
```