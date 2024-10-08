import 'package:ref_core/ref_core.dart';
import 'package:test/test.dart';

class Point {
  Point(this.x, this.y);

  final int x;
  final int y;
}

void main() {
  test('can be instantiated', () {
    expect(Ref<dynamic>(() => 1), isNotNull);
  });

  test('should lazily instantiate', () {
    var called = 0;

    Point create() {
      called++;
      return Point(1, 2);
    }

    final ref = Ref<Point>(create);

    expect(called, 0);

    ref.overrideWith(create);

    expect(called, 0);

    ref();

    expect(called, 1);

    ref();

    expect(called, 1);
  });

  test('returns same instance', () {
    final ref = Ref(() => Point(1, 2));
    expect(ref() == ref(), isTrue);
    expect(ref() == ref(), isTrue);
  });

  test('should throws a unimplemented error', () {
    final ref = Ref<Point>(() => throw UnimplementedError());

    expect(() => ref(), throwsUnimplementedError);
  });

  test('should override with new create function', () {
    final ref = Ref(() => Point(1, 2));

    expect(ref().x, 1);

    ref.overrideWith(() => Point(3, 4));

    expect(ref().x, 3);
  });

  test('should try to recreate the instance if exception is thrown', () {
    var fail = true;
    var called = 0;
    final ref = Ref<Point>(
      () {
        called++;
        return fail ? throw Exception() : Point(1, 2);
      },
    );

    expect(ref.call, throwsException);

    expect(called, 1);

    fail = false;

    expect(ref().x, 1);

    expect(called, 2);

    expect(ref().x, 1);

    expect(called, 2);
  });

  test('should work with uninitialized ref', () {
    late final Ref<Point> ref1;

    final ref2 = Ref(() => Point(1, ref1().y));

    ref1 = Ref(() => Point(5, 6));

    expect(ref1().x, 5);
    expect(ref1().y, 6);
    expect(ref2().x, 1);
    expect(ref2().y, 6);
  });
}
