import 'package:oktoast/oktoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod_hooks/features/todo/providers/todo_models.dart';
import 'package:flutter_riverpod_hooks/core/network/network_client.dart';

part 'todo_provider.g.dart';

@riverpod
class TodoList extends _$TodoList {
  @override
  List<Todo> build() {
    return [];
  }

  // 获取 Todo 列表 (GET /todo)
  Future<void> fetchTodos({int page = 1, int limit = 20}) async {
    try {
      final response = await ref
          .read(authenticatedDioProvider)
          .get('/todo/list', queryParameters: {'page': page, 'limit': limit});

      if (response.statusCode == 200 && response.data['code'] == 200) {
        final dynamic innerData = response.data['data'];
        if (innerData is List) {
          state = innerData.map((item) => Todo.fromJson(item)).toList();
        } else if (innerData is Map && innerData.containsKey('list')) {
          // 处理带分页的结构
          final List<dynamic> list = innerData['list'];
          state = list.map((item) => Todo.fromJson(item)).toList();
        }
      }
      showToast(response.data["msg"] ?? "获取成功");
    } catch (e) {
      print('Fetch Todos Error: $e');
    }
  }

  // 创建 Todo (POST /todo)
  Future<void> addTodo(String title) async {
    final dto = CreateTodoDto(title: title);
    try {
      final response = await ref
          .read(authenticatedDioProvider)
          .post('/todo/create', data: dto.toJson());
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['code'] == 200) {
        final newTodo = Todo.fromJson(response.data['data']);
        state = [...state, newTodo];
      }
    } catch (e) {
      print('Add Todo Error: $e');
    }
  }

  // 更新 Todo (PUT /todo)
  Future<void> toggleTodo(Todo todo) async {
    final updatedTodo = todo.copyWith(completed: !todo.completed);
    final dto = UpdateTodoDto(
      id: updatedTodo.id,
      title: updatedTodo.title,
      completed: updatedTodo.completed,
    );

    try {
      final response = await ref
          .read(authenticatedDioProvider)
          .put('/todo/update', data: dto.toJson());
      if (response.statusCode == 200 && response.data['code'] == 200) {
        state = [
          for (final t in state)
            if (t.id == todo.id) updatedTodo else t,
        ];
      }
    } catch (e) {
      print('Toggle Todo Error: $e');
    }
  }

  // 删除 Todo (DELETE /todo)
  Future<void> removeTodo(int id) async {
    final dto = DeleteTodoDto(id: id);
    try {
      final response = await ref
          .read(authenticatedDioProvider)
          .delete('/todo/delete', data: dto.toJson());
      if (response.statusCode == 200 && response.data['code'] == 200) {
        state = state.where((t) => t.id != id).toList();
      }
    } catch (e) {
      print('Remove Todo Error: $e');
    }
  }
}
