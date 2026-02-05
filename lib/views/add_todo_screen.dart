import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mvvm_task_management/app/app_colors.dart';
import 'package:mvvm_task_management/models/todo_model.dart';
import 'package:mvvm_task_management/utils/show_snackbar.dart';
import 'package:mvvm_task_management/view_models/todo_provider.dart';
import 'package:mvvm_task_management/widgets/btn_loading_widget.dart';
import 'package:provider/provider.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});
  static String name = 'addTodoScreen';
  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _file;
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

  void craeteTodo() async {
    DateTime? dt;
    if (_dateTimeTEC.text.isNotEmpty) {
      DateFormat format = DateFormat.yMMMEd().add_Hm();
      dt = format.parse(_dateTimeTEC.text);
    }
    TodoModel model = TodoModel(
      status: 0,
      todo: _todoTEC.text.trim(),
      deadline: dt?.millisecondsSinceEpoch,
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
                  decoration: InputDecoration(
                    labelText: 'What to do?',
                    suffix: Consumer<TodoProvider>(
                      builder: (context, value, child) => Visibility(
                        visible: value.textRecognizing == false,
                        replacement: CircularProgressIndicator(
                          backgroundColor: AppColors.themeColor,
                        ),
                        child: IconButton(
                          onPressed: () => _uploadImage(context),
                          icon: Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                    ),
                  ),
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
                    replacement: Center(child: BtnLoadingWidget()),
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

  Future<void> _uploadImage(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Camera'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    TodoProvider tp = context.read<TodoProvider>();
    tp.changeTextREcognizingStatus = true;
    _file = await _picker.pickImage(source: source);
    if (_file != null) {
      CroppedFile? cropedFile = await _cropImage(_file!);
      if (cropedFile != null) {
        final InputImage inputImage = InputImage.fromFilePath(cropedFile.path);
        final textRecognizer = TextRecognizer();
        final RecognizedText recognizedText = await textRecognizer.processImage(
          inputImage,
        );

        String text = recognizedText.text;
        _todoTEC.text = text;
      }
    }
    tp.changeTextREcognizingStatus = false;
  }

  Future<CroppedFile?> _cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: AppColors.themeColor,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
      ],
    );
    return croppedFile;
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
