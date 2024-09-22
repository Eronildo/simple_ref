import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_ref/simple_ref.dart';

void main() {
  testWidgets(
    'should dispose Disposable when no dispose function is supplied',
    (tester) async {
      final resource = _Resource();
      final refResource = Ref.autoDispose((_) => resource);
      final show = ValueNotifier(true);

      await tester.pumpWidget(
        MaterialApp(
          home: RefScope(
            child: ListenableBuilder(
              listenable: show,
              builder: (context, snapshot) {
                if (!show.value) return const Text('hidden');
                return Builder(
                  builder: (context) {
                    final val = refResource(context);
                    return Text('${val.disposed}');
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('false'), findsOneWidget);

      expect(resource.disposed, false);

      show.value = false;

      await tester.pumpAndSettle();

      expect(find.text('hidden'), findsOneWidget);

      expect(resource.disposed, true);
    },
  );

  testWidgets(
    'should dispose correct instance when overriden',
    (tester) async {
      final resource = _Resource();
      final resource2 = _Resource();
      final refResource = Ref.autoDispose((context) => resource);
      refResource.overrideWith((_) => resource2);
      final show = ValueNotifier(true);

      await tester.pumpWidget(
        MaterialApp(
          home: RefScope(
            child: ListenableBuilder(
              listenable: show,
              builder: (context, snapshot) {
                return !show.value
                    ? const Text('hidden')
                    : Column(
                        children: [
                          Builder(
                            builder: (context) {
                              final val = refResource(context);
                              return Text('${val.disposed}');
                            },
                          ),
                          Builder(
                            builder: (context) {
                              final val = refResource(context);
                              return Text('${val.disposed}');
                            },
                          ),
                        ],
                      );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('false'), findsExactly(2));

      expect(resource.disposed, false);
      expect(resource2.disposed, false);

      show.value = false;

      await tester.pumpAndSettle();

      expect(find.text('hidden'), findsOneWidget);

      expect(resource.disposed, false);
      expect(resource2.disposed, true);
    },
  );

  testWidgets('should fetch from the closest scope', (tester) async {
    final refResource = Ref.autoDispose((_) => _Resource());

    await tester.pumpWidget(
      MaterialApp(
        home: RefScope(
          child: Builder(
            builder: (context) {
              final val = refResource(context);
              expect(val.disposed, false);
              val.disposed = true;

              refResource.overrideWith((context) => _Resource());

              return Builder(
                builder: (context) {
                  final val2 = refResource(context);
                  expect(val2.disposed, false);
                  return Text('${val2.disposed}');
                },
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('false'), findsOneWidget);
  });
}

class _Resource implements Disposable {
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
  }
}
