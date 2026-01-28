import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:mvvm_task_management/app/app_colors.dart';

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
      minTime: DateTime(2018, 3, 5),
      maxTime: DateTime(2019, 6, 7),
      onConfirm: (date) {
        DateFormat format = DateFormat.yMMMEd().add_Hm();
        _dateTimeTEC.text = format.format(date);
        setState(() {});
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
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
                ElevatedButton(onPressed: () {}, child: Text('Create Todo')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
