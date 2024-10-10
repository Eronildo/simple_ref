<p align="center">
<a href="https://pub.dev/packages/ref_core"><img src="https://img.shields.io/pub/v/ref_core.svg?color=blue" alt="Pub"></a>
<a href="https://github.com/Eronildo/simple_ref"><img src="https://img.shields.io/github/stars/Eronildo/simple_ref.svg?style=flat&logo=github&colorB=blue&label=stars" alt="Star on Github"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

## The core of the Simple Ref package:
| Package                              | Pub                                                           |
| ------------------------------------ | ------------------------------------------------------------- |
| [simple_ref][simple_ref_git_link]    | [![pub package][simple_ref_pub_badge]][simple_ref_pub_link]   |

---

## Ref Core

A simple and lightweight service locator reference library with overrides support for Dart.

## Installation

```console
dart pub add ref_core
```

## Usage

```dart
import 'package:ref_core.dart';

final refCounter = Ref(() => 0);

final counter = refCounter();
```

[simple_ref_pub_badge]: https://img.shields.io/pub/v/simple_ref.svg
[simple_ref_pub_link]: https://pub.dev/packages/simple_ref
[simple_ref_git_link]: https://github.com/Eronildo/simple_ref/tree/master/packages/simple_ref
