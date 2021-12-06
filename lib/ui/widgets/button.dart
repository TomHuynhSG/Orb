import 'package:flutter/material.dart';
import 'package:flutter_project_devfest/ui/size_config.dart';
import 'package:flutter_project_devfest/ui/theme.dart';

class MyButton extends StatelessWidget {
  final Function onTap;
  final String label;

  MyButton({
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 50,
        width: 130,
        decoration: BoxDecoration(
          color: primaryClr,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
