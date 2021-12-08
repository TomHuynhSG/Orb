import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:orbit/controllers/task_controller.dart';
import 'package:orbit/models/task.dart';
import 'package:orbit/ui/theme.dart';
import 'package:orbit/ui/widgets/button.dart';
import 'package:orbit/ui/widgets/input_field.dart';
import 'package:intl/intl.dart';
import 'package:orbit/ui/pages/home_page.dart';
import 'package:flutter/cupertino.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.find<TaskController>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(minutes: 5));

  late String _startTime = DateFormat('hh:mm a').format(_startDate).toString();
  late String _endTime = DateFormat('hh:mm a').format(_endDate).toString();

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    final format = DateFormat.jm();
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              InputField(
                title: "Title",
                hint: "Enter title here.",
                controller: _titleController,
              ),
              InputField(
                  title: "Note",
                  hint: "Enter note here.",
                  controller: _noteController),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Date",
                      hint: DateFormat('dd/MM/yyyy').format(_startDate),
                      widget: IconButton(
                        icon: (const Icon(
                          FlutterIcons.calendar_ant,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          _getDateFromUser(isStartTime: true);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        icon: (const Icon(
                          FlutterIcons.clock_faw5,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                          setState(() {});
                        },
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "End Date",
                      hint: DateFormat('dd/MM/yyyy').format(_endDate),
                      widget: IconButton(
                        icon: (const Icon(
                          FlutterIcons.calendar_ant,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          _getDateFromUser(isStartTime: false);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        icon: (const Icon(
                          FlutterIcons.clock_faw5,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 18.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorChips(),
                  MyButton(
                    label: "Create Task",
                    onTap: () {
                      _validateInputs();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateInputs() {
    if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    
    if(_startDate.isAfter(_endDate)) {
      Get.snackbar(
        "Invalid datetime",
        "Start date cannot be after end date",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // DateTime _now = new DateTime.now();

    // DateTime start = DateFormat('dd/MM/yyyy HH:mm aa')
    //     .parse('${task.date} ${task.startTime}');
    // DateTime end =
    //     DateFormat('dd/MM/yyyy HH:mm aa').parse('${task.date} ${task.endTime}');

    // tz.TZDateTime tzStart = tz.TZDateTime(
    //     tz.local, _now.year, _now.month, _now.day, start.hour, start.minute);

    // tz.TZDateTime tzEnd = tz.TZDateTime(
    //     tz.local, _now.year, _now.month, _now.day, end.hour, end.minute);

    // tz.TZDateTime tzNow = tz.TZDateTime(tz.local, _now.year, )



    _addTaskToDB();
    Get.back();
  }

  _addTaskToDB() async {
    DateTime startDate = DateFormat('MM/dd/yyyy hh:mm a').parse('${DateFormat.yMd().format(_startDate)} $_startTime');
    DateTime endDate = DateFormat('MM/dd/yyyy hh:mm a').parse('${DateFormat.yMd().format(_endDate)} $_endTime');
    await _taskController.addTask(
      task: Task(
        note: _noteController.text,
        title: _titleController.text,
        startDate: startDate.toString(),
        endDate: endDate.toString(),
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
  }

  _colorChips() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Color",
        style: titleTextStle,
      ),
      const SizedBox(
        height: 8,
      ),
      Wrap(
        children: List<Widget>.generate(
          3,
          (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: index == _selectedColor
                      ? const Center(
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      : Container(),
                ),
              ),
            );
          },
        ).toList(),
      ),
    ]);
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, size: 24, color: primaryClr),
        ),
        actions: [
          Icon(
              Get.isDarkMode
                  ? FlutterIcons.user_circle_faw
                  : FlutterIcons.user_circle_o_faw,
              color: Get.isDarkMode ? Colors.white : darkGreyClr),
          const SizedBox(
            width: 20,
          ),
        ]);
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker(isStartTime: isStartTime);
    String _formatedTime = _pickedTime.format(context);
    if (isStartTime) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker({required bool isStartTime}) async {
    return showTimePicker(
      initialTime: TimeOfDay(
          hour: isStartTime ? _startDate.hour : _endDate.hour,
          minute: isStartTime ? _startDate.minute : _endDate.minute),
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
    );
  }

  _getDateFromUser({required bool isStartTime}) async {
    final DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: isStartTime ? _startDate : _endDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));

    if (_pickedDate == null) return;

    if(isStartTime == true) {
      setState(() {
        _startDate = _pickedDate;
      });
    } else {
      setState(() {
        _endDate = _pickedDate;
      });
    }
  }
}
