import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mvvm_task_management/models/todo_model.dart';

class TodoCardWidget extends StatelessWidget {
  const TodoCardWidget(this.model, {super.key});

  final TodoModel model;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: DrawerMotion(),

        children: [
          SlidableAction(
            onPressed: (context) {},
            label: 'Edit',
            icon: Icons.edit,
            backgroundColor: Colors.lightBlueAccent,
          ),
          SlidableAction(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            onPressed: (context) {},
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
                      PopupMenuItem(child: Text('Complete')),
                      PopupMenuItem(child: Text('Cancel')),
                    ],
                  ),
                  Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(100),
                    ),
                    label: Text('Completed'),
                  ),
                  Text('Remain : 2days'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
