import 'package:day_47/coures/add_course.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class viewCourse extends StatefulWidget {
  const viewCourse({super.key});

  @override
  State<viewCourse> createState() => _viewCourseState();
}

class _viewCourseState extends State<viewCourse> {
  addNewCourse() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: ((context) => addCourse()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Course"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewCourse();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
