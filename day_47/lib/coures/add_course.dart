import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class addCourse extends StatefulWidget {
  const addCourse({super.key});

  @override
  State<addCourse> createState() => _addCourseState();
}

class _addCourseState extends State<addCourse> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
    );
  }
}
