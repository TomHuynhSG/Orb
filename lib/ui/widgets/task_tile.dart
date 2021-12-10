import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orbit/models/task.dart';
import 'package:orbit/ui/size_config.dart';
import 'package:orbit/ui/theme.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  // ignore: use_key_in_widget_constructors
  const TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime.parse(task.startDate);
    DateTime endDate = DateTime.parse(task.endDate);

    String ymdStartDate = DateFormat('dd/MM/yyyy').format(startDate);
    String ymdEndDate = DateFormat('dd/MM/yyyy').format(endDate);

    String hmStartDate = DateFormat('HH:mm aa').format(startDate);
    String hmEndDate = DateFormat('HH:mm aa').format(endDate);

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: task.isCompleted == 1 ? successClr : _getBGClr(task.color),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FlutterIcons.play_fou,
                      color: Colors.grey[200],
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$ymdStartDate - $hmStartDate',
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: 13, color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),
                 const SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FlutterIcons.stop_fou,
                      color: Colors.grey[200],
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$ymdEndDate - $hmEndDate",
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: 13, color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  task.note,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 15, color: Colors.grey[100]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task.isCompleted == 1 ? "COMPLETED" : "TODO",
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return bluishClr;
    }
  }
}
