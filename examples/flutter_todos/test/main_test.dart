import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos/main.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_ref/simple_ref.dart';

class MockTodosNotifier extends Mock implements TodosNotifier {}

void main() {
  final todosNotifier = MockTodosNotifier();

  setUp(() {
    when(() => todosNotifier.isLoading).thenReturn(false);
    when(() => todosNotifier.todos).thenReturn(['someTodo', 'otherTodo']);
    refTodosNotifier.overrideWith((_) => todosNotifier);
  });

  testWidgets('main ...', (tester) async {
    await tester.pumpWidget(const RefScope(child: MainApp()));

    final goToTodosButton = find.byType(OutlinedButton);
    await tester.tap(goToTodosButton);

    await tester.pumpAndSettle();

    final todoListView = find.byType(ListView);
    expect(todoListView, findsOne);

    final someTodoText = find.text(' - someTodo');
    expect(someTodoText, findsOne);

    final todosListTile = find.byType(ListTile);
    expect(todosListTile, findsNWidgets(2));
  });
}
