import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'todo_models.dart';
import 'todo_provider.dart';
import 'auth_provider.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return OKToast(
      child: MaterialApp(
        title: 'Riverpod Todo List',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: authState.when(
          data: (isAuth) => isAuth ? const TodoPage() : const AuthPage(),
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (err, stack) =>
              Scaffold(body: Center(child: Text('Error: $err'))),
        ),
      ),
    );
  }
}

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLogin = useState(true);

    return Scaffold(
      appBar: AppBar(title: Text(isLogin.value ? '登录' : '注册')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: '用户名'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: '密码'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final username = usernameController.text;
                final password = passwordController.text;
                try {
                  if (isLogin.value) {
                    await ref
                        .read(authProvider.notifier)
                        .login(username, password);
                  } else {
                    await ref
                        .read(authProvider.notifier)
                        .register(username, password);
                  }
                } catch (e) {
                  showToast('操作失败: $e');
                }
              },
              child: Text(isLogin.value ? '登录' : '注册'),
            ),
            TextButton(
              onPressed: () => isLogin.value = !isLogin.value,
              child: Text(isLogin.value ? '没有账号？去注册' : '已有账号？去登录'),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoPage extends HookConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListProvider);
    final textController = useTextEditingController();

    // 初始加载
    useEffect(() {
      Future.microtask(() => ref.read(todoListProvider.notifier).fetchTodos());
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      labelText: '输入任务内容',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      ref
                          .read(todoListProvider.notifier)
                          .addTodo(textController.text);
                      textController.clear();
                    }
                  },
                  child: const Text('新增'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                final Todo todo = todoList[index];
                return ListTile(
                  key: Key(todo.id.toString()),
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (val) {
                      ref.read(todoListProvider.notifier).toggleTodo(todo);
                    },
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref.read(todoListProvider.notifier).removeTodo(todo.id);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
