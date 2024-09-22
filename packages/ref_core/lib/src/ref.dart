/// A function that creates an instance of [T].
typedef RefCallback<T> = T Function();

/// {@template ref}
/// A [Ref] is a reference that returns an instance of [T].
/// {@endtemplate}
class Ref<T> {
  /// {@macro ref}
  Ref(RefCallback<T> create) : _create = create;

  RefCallback<T> _create;
  T? _instance;

  /// Override the function used to create an instance of [T].
  void overrideWith(RefCallback<T> create) {
    _instance = null;
    _create = create;
  }

  /// Returns the instance of [T].
  T call() => _instance ??= _create();
}
