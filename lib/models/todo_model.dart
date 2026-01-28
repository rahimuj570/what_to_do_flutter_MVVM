class TodoModel {
  final int id;
  final String todo;
  final DateTime? deadline;

  TodoModel({required this.id, required this.todo, required this.deadline});

  Map<String, dynamic> toJson() {
    return {'id': id, 'todo': todo, 'deadline': deadline};
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      todo: json['todo'],
      deadline: json['deadline'],
    );
  }
}
