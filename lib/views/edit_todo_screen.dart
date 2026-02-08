import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:mvvm_task_management/app/app_colors.dart';
import 'package:mvvm_task_management/models/todo_model.dart';
import 'package:mvvm_task_management/utils/show_snackbar.dart';
import 'package:mvvm_task_management/view_models/todo_provider.dart';
import 'package:mvvm_task_management/widgets/btn_loading_widget.dart';
import 'package:provider/provider.dart';

class EditTodoScreen extends StatefulWidget {
  final TodoModel model;
  const EditTodoScreen({super.key, required this.model});
  static String name = 'EditTodoScreen';
  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final TextEditingController _todoTEC = TextEditingController();
  final TextEditingController _dateTimeTEC = TextEditingController();
  Locale l = WidgetsBinding.instance.platformDispatcher.locale;

  void removeDeadeline() {
    setState(() {
      _dateTimeTEC.clear();
    });
  }

  void showDate() {
    DatePicker.showDateTimePicker(
      context,

      showTitleActions: true,
      minTime: (DateTime.now().add(Duration(minutes: 10))),
      maxTime: DateTime.now().add(Duration(days: 365 * 5)),
      currentTime: (DateTime.now().add(Duration(minutes: 10))),
      onConfirm: (date) {
        DateFormat format = DateFormat.yMMMEd().add_Hm();
        _dateTimeTEC.text = format.format(date);
        setState(() {});
      },
      locale: LocaleType.en,
    );
  }

  void updateTodo() async {
    DateTime? dt;
    if (_dateTimeTEC.text.isNotEmpty) {
      DateFormat format = DateFormat.yMMMEd().add_Hm();
      dt = format.parse(_dateTimeTEC.text);
    }
    TodoModel model = TodoModel(
      status: widget.model.status,
      id: widget.model.id,
      todo: _todoTEC.text.trim(),
      deadline: dt?.millisecondsSinceEpoch,
    );
    try {
      int count = await context.read<TodoProvider>().updateTodo(model);

      if (count != 0) {
        if (mounted) {
          showSnackBar(context: context, message: 'Sucessfully updated');
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          showSnackBar(
            context: context,
            message: 'Something went wrong',
            isFailed: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context: context,
          message: 'Something went wrong',
          isFailed: true,
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _todoTEC.text = widget.model.todo;
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _todoTEC.dispose();
    _dateTimeTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Todo')),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: Column(
              children: [
                TextField(
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  maxLines: 3,
                  controller: _todoTEC,
                  decoration: InputDecoration(labelText: 'What to do?'),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: _dateTimeTEC,
                        enabled: false,
                        decoration: InputDecoration(labelText: 'Deadline'),
                      ),
                    ),
                    SizedBox(
                      height: kTextTabBarHeight + 5,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size.fromWidth(double.infinity),
                          shape: RoundedRectangleBorder(),
                          backgroundColor: _dateTimeTEC.text.isEmpty
                              ? AppColors.themeColor
                              : Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _dateTimeTEC.text.isEmpty
                            ? showDate
                            : removeDeadeline,
                        child: Text(
                          _dateTimeTEC.text.isEmpty ? 'Add Deadline' : 'Remove',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Consumer<TodoProvider>(
                  builder: (context, value, child) => Visibility(
                    visible: value.getIsUpdatingTodo == false,
                    replacement: Center(child: BtnLoadingWidget()),
                    child: ElevatedButton(
                      onPressed: updateTodo,
                      child: Text('Update Todo'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
