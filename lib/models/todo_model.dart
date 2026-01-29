class TodoModel {
  final int? id;
  final String todo;
  final int? deadline;
  int status; //0=inprogress; 1=completed; 2=cacelled

  TodoModel({
    this.id,
    required this.status,
    required this.todo,
    required this.deadline,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'todo': todo, 'deadline': deadline, 'status': status};
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      todo: json['todo'],
      deadline: json['deadline'],
      status: json['status'],
    );
  }
}
