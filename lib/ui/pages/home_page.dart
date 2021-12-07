import 'dart:async';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orbit/controllers/task_controller.dart';
import 'package:orbit/models/task.dart';
import 'package:orbit/services/notification_services.dart';
import 'package:orbit/ui/pages/add_task_page.dart';
import 'package:orbit/ui/size_config.dart';
import 'package:orbit/ui/theme.dart';
import 'package:orbit/ui/widgets/button.dart';
import 'package:intl/intl.dart';
import 'package:orbit/ui/widgets/task_tile.dart';

import '../../services/theme_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.parse(DateTime.now().toString());
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  bool animate = false;
  double left = 630;
  double top = 900;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();

    _timer = Timer(const Duration(milliseconds: 500), () {
      notifyHelper.initializeNotification(context);
      notifyHelper.requestIOSPermissions();
      setState(() {
        animate = true;
        left = 30;
        top = top / 3;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(context),
          _dateBar(),
          const SizedBox(
            height: 12,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _dateBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 20),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: DatePicker(
          DateTime.now(),
          height: 100.0,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectionColor: primaryClr,
          //selectedTextColor: primaryClr,
          selectedTextColor: Colors.white,
          dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 10.0,
              color: Colors.grey,
            ),
          ),

          onDateChange: (date) {
            // New date selected

            setState(
              () {
                _selectedDate = date;
              },
            );
          },
        ),
      ),
    );
  }

  _addTaskBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingTextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Today",
                style: headingTextStyle,
              ),
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => AddTaskPage(),
                ),
              ).then((value) => setState(() {
                    _taskController.getTasks();
                  }));

              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            ThemeService().switchTheme();
          },
          child: Icon(
              Get.isDarkMode ? FlutterIcons.sun_fea : FlutterIcons.moon_fea,
              color: Get.isDarkMode ? Colors.white : darkGreyClr),
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

  _showTasks() {
    return Expanded(
      child: Obx(() {
        bool isEmpty = true;
        for (var task in _taskController.taskList) {
          if (task.date == DateFormat.yMd().format(_selectedDate)) {
            isEmpty = false;
          }
        }
        if (isEmpty) return _noTaskMsg();

        return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _taskController.taskList.length,
            itemBuilder: (context, index) {
              Task task = _taskController.taskList[index];
              if (task.date != DateFormat.yMd().format(_selectedDate)) return Container();
              notifyHelper.scheduledNotification(task);

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1375),
                child: SlideAnimation(
                  horizontalOffset: 300.0,
                  child: FadeInAnimation(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              showBottomSheet(context, task);
                            },
                            child: TaskTile(task)),
                      ],
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? SizeConfig.screenHeight * 0.24
            : SizeConfig.screenHeight * 0.32,
        width: SizeConfig.screenWidth,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          const Spacer(),
          task.isCompleted == 1
              ? Container()
              : _buildBottomSheetButton(
                  label: "Task Completed",
                  onTap: () {
                    _taskController.markTaskCompleted(task.id!);
                    Get.back();
                  },
                  clr: successClr),
          _buildBottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.deleteTask(task);
                Get.back();
              },
              clr: primaryClr),
          const SizedBox(
            height: 15,
          ),
          _buildBottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              isClose: true),
        ]),
      ),
    );
  }

  _buildBottomSheetButton(
      {required String label,
      required Function onTap,
      Color? clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 50,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr!,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
          label,
          style: isClose
              ? titleTextStle
              : titleTextStle.copyWith(color: Colors.white),
        )),
      ),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
          Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "images/logo.png",
                color: primaryClr.withOpacity(0.5),
                height: 90,
                // semanticsLabel: 'Task',
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  "You do not have any tasks yet!\nAdd new tasks to make your days productive.",
                  textAlign: TextAlign.center,
                  style: subTitleTextStle,
                ),
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          )),
      ],
    );
  }
}
