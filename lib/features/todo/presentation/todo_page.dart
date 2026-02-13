import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod_hooks/features/todo/providers/todo_models.dart';
import 'package:flutter_riverpod_hooks/features/todo/providers/todo_provider.dart';

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
        title: const Text('任务列表'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
