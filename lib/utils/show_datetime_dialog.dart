import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';

Future<String> showDateTimeDialog(BuildContext context) async {
  DateTime? dt = await DatePicker.showDateTimePicker(
    context,
    showTitleActions: true,
    minTime: (DateTime.now().add(Duration(minutes: 10))),
    maxTime: DateTime.now().add(Duration(days: 365 * 5)),
    currentTime: (DateTime.now().add(Duration(minutes: 10))),
    locale: LocaleType.en,
  );

  if (dt != null) {
    DateFormat format = DateFormat.yMMMEd().add_Hm();
    return format.format(dt);
  }
  return '';
}
