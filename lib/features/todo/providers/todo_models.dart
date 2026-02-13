class LoginAndRegisterDto {
  final String username;
  final String password;

  LoginAndRegisterDto({required this.username, required this.password});

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}

class CreateTodoDto {
  final String title;

  CreateTodoDto({required this.title});

  Map<String, dynamic> toJson() => {'title': title};
}

class GetTodoListDto {
  final int? page;
  final int? limit;

  GetTodoListDto({this.page, this.limit});

  Map<String, dynamic> toJson() => {
    if (page != null) 'page': page,
    if (limit != null) 'limit': limit,
  };
}

class UpdateTodoDto {
  final int id;
  final String title;
  final bool completed;

  UpdateTodoDto({
    required this.id,
    required this.title,
    required this.completed,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': completed,
  };
}

class DeleteTodoDto {
  final int id;

  DeleteTodoDto({required this.id});

  Map<String, dynamic> toJson() => {'id': id};
}

class Todo {
  final int id;
  final String title;
  final bool completed;

  Todo({required this.id, required this.title, required this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: (json['id'] ?? json['ID']) as int,
      title: (json['title'] ?? json['Title']) as String,
      completed: (json['completed'] ?? json['Completed']) as bool,
    );
  }

  Todo copyWith({int? id, String? title, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
