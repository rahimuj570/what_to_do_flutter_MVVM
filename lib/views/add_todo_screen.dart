import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:mvvm_task_management/app/app_colors.dart';
import 'package:mvvm_task_management/models/todo_model.dart';
import 'package:mvvm_task_management/utils/show_snackbar.dart';
import 'package:mvvm_task_management/view_models/todo_provider.dart';
import 'package:mvvm_task_management/widgets/btn_loading.dart';
import 'package:provider/provider.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});
  static String name = 'addTodoScreen';
  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
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
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(Duration(days: 365 * 5)),
      onConfirm: (date) {
        DateFormat format = DateFormat.yMMMEd().add_Hm();
        _dateTimeTEC.text = format.format(date);
        setState(() {});
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  void craeteTodo() async {
    DateTime? dt;
    if (_dateTimeTEC.text.isNotEmpty) {
      DateFormat format = DateFormat.yMMMEd().add_Hm();
      dt = format.parse(_dateTimeTEC.text);
    }
    TodoModel model = TodoModel(
      status: 0,
      todo: _todoTEC.text.trim(),
      deadline: dt?.microsecondsSinceEpoch,
    );
    try {
      int count = await context.read<TodoProvider>().addTodo(model);

      if (count != 0) {
        if (mounted) {
          showSnackBar(context: context, message: 'Sucessfully created');
          _todoTEC.text = '';
          _dateTimeTEC.text = '';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Todo')),
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
                    visible: value.getIsCreatingTodo == false,
                    replacement: Center(child: BtnLoading()),
                    child: ElevatedButton(
                      onPressed: craeteTodo,
                      child: Text('Create Todo'),
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
