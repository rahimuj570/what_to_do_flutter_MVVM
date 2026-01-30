import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mvvm_task_management/models/todo_model.dart';
import 'package:mvvm_task_management/utils/show_snackbar.dart';
import 'package:mvvm_task_management/utils/task_status_get.dart';
import 'package:mvvm_task_management/view_models/todo_provider.dart';
import 'package:mvvm_task_management/views/edit_todo_screen.dart';
import 'package:provider/provider.dart';

class TodoCardWidget extends StatelessWidget {
  const TodoCardWidget(this.model, {super.key});

  final TodoModel model;
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) => Slidable(
        endActionPane: ActionPane(
          motion: DrawerMotion(),

          children: [
            SlidableAction(
              onPressed: (context) {
                Navigator.pushNamed(
                  context,
                  EditTodoScreen.name,
                  arguments: model,
                );
              },
              label: 'Edit',
              icon: Icons.edit,
              backgroundColor: Colors.lightBlueAccent,
            ),
            SlidableAction(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              onPressed: (context) async {
                int count = await todoProvider.deleteTodo(model.id!);
                if (context.mounted) {
                  if (count != 0) {
                    showSnackBar(
                      context: context,
                      message: 'Successfully deleted',
                    );
                  } else {
                    showSnackBar(
                      context: context,
                      message: 'Something went wrong',
                    );
                  }
                }
              },
              label: 'Delete',
              icon: Icons.delete_forever,
              backgroundColor: Colors.red,
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          color: Colors.white,
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(model.todo)),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        if (model.status != 0)
                          PopupMenuItem(
                            child: Text(getMenuName(0)),
                            onTap: () => onTapChangeStatus(context, 0, model),
                          ),
                        if (model.status != 1)
                          PopupMenuItem(
                            child: Text(getMenuName(1)),
                            onTap: () {
                              onTapChangeStatus(context, 1, model);
                            },
                          ),
                        if (model.status != 2)
                          PopupMenuItem(
                            child: Text(getMenuName(2)),
                            onTap: () => onTapChangeStatus(context, 2, model),
                          ),
                      ],
                    ),
                    Chip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(100),
                      ),
                      label: Text(getChipName(model.status)),
                    ),
                    Text(
                      'Remain : ${model.deadline != null ? getRemainTime(model.deadline!) : 'N/A'}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getRemainTime(int milisec) {
    String remain = '';
    int days = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.fromMillisecondsSinceEpoch(milisec),
    ).duration.inDays;
    int hours = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.fromMillisecondsSinceEpoch(milisec),
    ).duration.inHours;

    int minutes = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.fromMillisecondsSinceEpoch(milisec),
    ).duration.inMinutes;

    if (days != 0) {
      remain = '$days days';
    } else if (hours != 0) {
      remain = '$hours hours';
    } else {
      remain = '$minutes minutes';
    }

    return remain;
  }
}

void onTapChangeStatus(
  BuildContext context,
  int newStatus,
  TodoModel model,
) async {
  int count = await context.read<TodoProvider>().changeTodoStatus(
    newStatus,
    model,
  );
  if (context.mounted) {
    if (count != 0) {
      showSnackBar(
        context: context,
        message: 'Todo marked as ${getMenuName(newStatus)}ed',
      );
    } else {
      showSnackBar(
        isFailed: true,
        context: context,
        message: 'Something went wrong',
      );
    }
  }
}
