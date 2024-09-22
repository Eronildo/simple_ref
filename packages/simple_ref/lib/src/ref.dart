import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'package:ref_core/ref_core.dart' as ref_core;

part 'ref_scope.dart';

/// A function that creates an instance of [T].
typedef AutoDisposeRefCallback<T extends Disposable> = T Function(
    BuildContext context);

/// {@template ref}
/// A [Ref] is a reference that returns an instance of [T].
/// {@endtemplate}
class Ref<T> extends ref_core.Ref<T> {
  /// {@macro ref}
  Ref(super.create);

  /// {@macro auto_dispose_ref}
  static AutoDisposeRef<T> autoDispose<T extends Disposable>(
          AutoDisposeRefCallback<T> create) =>
      AutoDisposeRef<T>._(create);
}

/// {@template auto_dispose_ref}
/// A [AutoDisposeRef] is a [Ref] that returns an instance of [T]
/// The reference will be discarded when the bound context is disposed.
/// {@endtemplate}
class AutoDisposeRef<T extends Disposable> {
  /// {@macro auto_dispose_ref}
  AutoDisposeRef._(AutoDisposeRefCallback<T> create) : _create = create;

  AutoDisposeRefCallback<T> _create;
  T? _instance;

  void _dispose() {
    if (_instance case final value?) {
      value.dispose();
      _instance = null;
    }
  }

  /// Override the function used to create an instance of [T].
  void overrideWith(AutoDisposeRefCallback<T> create) {
    _instance = null;
    _create = create;
  }

  /// Returns the instance of [T]
  /// Equivalent to calling the [of].
  T call(BuildContext context) {
    return of(context);
  }

  /// Returns the instance of [T].
  T of(BuildContext context) {
    final val = _instance ??= _create(context);

    assert(
      context is Element,
      'This must be called with the context of a Widget or a Ref.',
    );

    RefScope._of(context)._bindRef(context as Element, this);

    return val;
  }

  @override
  bool operator ==(covariant AutoDisposeRef<T> other) {
    if (identical(this, other)) return true;

    return other._create == _create && other._instance == _instance;
  }

  @override
  int get hashCode => _create.hashCode ^ _instance.hashCode;
}

/// An abstract class that provides a contract for disposing resources.
///
/// Classes that implement/mixin `Disposable` should override the `dispose` method
/// to release or cleanup resources such as file handles, database connections,
/// subscriptions, etc. This is crucial for preventing resource leaks in
/// applications.
abstract mixin class Disposable {
  /// Releases or cleans up resources used by the object.
  void dispose();
}
