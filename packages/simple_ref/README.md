<p align="center">
<a href="https://pub.dev/packages/simple_ref"><img src="https://img.shields.io/pub/v/simple_ref.svg?color=blue" alt="Pub"></a>
<a href="https://github.com/Eronildo/simple_ref"><img src="https://img.shields.io/github/stars/Eronildo/simple_ref.svg?style=flat&logo=github&colorB=blue&label=stars" alt="Star on Github"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

---

## Simple Ref

A simple, lightweight and auto disposable **service locator** reference library with overrides support for Flutter.

## Installation

```bash
flutter pub add simple_ref
```

## Usage

### Import package:

```dart
import 'package:simple_ref.dart';
```

### Singleton References:

```dart
final repositoryRef = Ref(() => Repository());

// or with tear-off
final repositoryRef = Ref(Repository.new);

// Access the instance
final repository = repositoryRef();

// Override
repositoryRef.overrideWith(() => MockRepository());
```

### For AutoDispose, wrap your app with a `RefScope`:

```dart
runApp(
    const RefScope(
        child: MyApp(),
    ),
);
```

### Implement, Extend or Mixin a `Disposable` and override the dispose method:

```dart
class Controller implements Disposable {
  final counter = ValueNotifier(0);

  @override
  void dispose() {
    counter.dispose();
  }
}
```

### Create a `AutoDisposeRef`:

```dart
final controllerRef = Ref.autoDispose((_) => Controller());
```

### Access the instance:

This can be done in a Widget or in a Ref by using `controllerRef.of(context)` or `controllerRef(context)`.

```dart
class CounterPage extends StatelessWidget {
    const CounterPage({super.key});

    @override
    Widget build(BuildContext context) {
        final controller = controllerRef.of(context);
        return Text('${controller.counter.value}');
    }
}
```

### Override it:

You can override the instance by using `overrideWith`. This is useful for testing or for initiate the async instances.
In the example below, all calls to `controllerRef.of(context)` will return `MockController`.

```dart
controllerRef.overrideWith((context) => MockController());
```
