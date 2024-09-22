part of 'ref.dart';

/// A widget that stores the state of the [Ref.autoDispose].
///
/// All Flutter applications using [Ref.autoDispose] must contain a [RefScope] at
/// the root of their widget tree. It is done as followed:
///
/// ```dart
/// void main() {
///   runApp(
///     // Enabled [Ref.autoDispose] for the entire application
///     RefScope(
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
class RefScope extends InheritedWidget {
  /// [RefScope] constructor.
  const RefScope({
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  @override
  InheritedElement createElement() => _RefScopeElement(this);

  static _RefScopeElement _of(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<RefScope>();

    assert(
      element != null,
      '''

  Wrap your app with `RefScope` in runApp:

  runApp(
    const RefScope( // <--
      child: MyApp(),
    ),
  );

  ''',
    );

    final refScopeElement = element! as _RefScopeElement;

    return refScopeElement;
  }
}

class _RefScopeElement extends InheritedElement {
  _RefScopeElement(super.widget);

  final _elementBindings = <Element, Set<AutoDisposeRef>>{};
  final _refBindings = <AutoDisposeRef, Set<Element>>{};

  void _bindRef(Element element, AutoDisposeRef ref) {
    final refBinding = _refBindings[ref];
    if (refBinding == null) {
      _refBindings[ref] = {element};
    } else {
      final hasElement = refBinding.contains(element);
      if (!hasElement) {
        refBinding.add(element);
      }
    }

    final binding = _elementBindings[element];
    if (binding == null) {
      _elementBindings[element] = {ref};

      element.dependOnInheritedElement(this);
      return;
    }

    final existing = binding.contains(ref);

    if (!existing) {
      binding.add(ref);

      element.dependOnInheritedElement(this);
    }
  }

  @override
  void removeDependent(Element dependent) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (dependent.mounted) return;

      final refs = _elementBindings.remove(dependent);

      if (refs == null) return;

      for (final ref in refs) {
        final elements = _refBindings[ref];
        if (elements != null) {
          elements.remove(dependent);

          if (elements.isEmpty) {
            ref._dispose();
            _refBindings.remove(ref);
          }
        }
      }
    });

    super.removeDependent(dependent);
  }
}
