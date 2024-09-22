import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ref/simple_ref.dart';

void main() => _bootstrap();

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  refSharedPreferences.overrideWith(() => sharedPreferences);

  runApp(const RefScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (_) => const HomePage(),
        TodosPage.routeName: (_) => const TodosPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: () => Navigator.pushNamed(context, TodosPage.routeName),
          child: const Text('Go to Todos Page'),
        ),
      ),
    );
  }
}

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  static String routeName = '/todos';

  @override
  Widget build(BuildContext context) {
    final todosNotifier = refTodosNotifier(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Todos'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: todosNotifier,
          builder: (_, __) {
            if (todosNotifier.isLoading) {
              return const CircularProgressIndicator.adaptive();
            }

            final todos = todosNotifier.todos;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (_, index) =>
                  ListTile(title: Text(' - ${todos[index]}')),
            );
          },
        ),
      ),
    );
  }
}

// Refs:
final refDio = Ref(Dio.new);
final refSharedPreferences =
    Ref<SharedPreferences>(() => throw UnimplementedError());
final refTodosNotifier = Ref.autoDispose(
  (_) => TodosNotifier(
    dio: refDio(),
    sharedPreferences: refSharedPreferences(),
  ),
);

// Todos Key for SharedPreferences
const todosKey = 'todos';

// Todos Controller:
class TodosNotifier with ChangeNotifier, Disposable {
  TodosNotifier({required this.dio, required this.sharedPreferences}) {
    debugPrint('Initialize TodosNotifier');
    _loadTodos();
  }

  final Dio dio;
  final SharedPreferences sharedPreferences;

  var todos = <String>[];
  var isLoading = false;

  void _setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setTodos(List<String> todoList) {
    todos = todoList;
    notifyListeners();
  }

  Future<void> _loadTodos() async {
    final storageTodos = _getOfflineTodos();
    if (storageTodos case final todoList?) {
      _setTodos(todoList);
      return;
    }

    _fetchTodos();
  }

  void _saveTodos(List<String> todos) {
    sharedPreferences.setStringList(todosKey, todos);
  }

  List<String>? _getOfflineTodos() => sharedPreferences.getStringList(todosKey);

  Future<void> _fetchTodos() async {
    _setIsLoading(true);
    try {
      await Future.delayed(Durations.medium4);
      final response =
          await dio.get<List>('https://jsonplaceholder.typicode.com/todos');
      todos = response.data?.map((e) => e['title'] as String).toList() ?? [];
      _saveTodos(todos);
    } catch (_) {
      todos = [];
    } finally {
      _setIsLoading(false);
    }
  }

  @override
  void dispose() {
    debugPrint('Dispose TodosNotifier');
    super.dispose();
  }
}
