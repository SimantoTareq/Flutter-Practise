import 'package:day_47/coures/add_course.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Stream<QuerySnapshot> _courseStream =
      FirebaseFirestore.instance.collection('courses').snapshots();

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
      body: StreamBuilder(
          stream: _courseStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something is wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return Container(
                  height: 350,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              Image.network(
                                data['img'],
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                height: 40,
                                width: 110,
                                child: Card(
                                  elevation: 5,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.delete)),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Container(
                        child: Text(data['course_name']),
                      ),
                      Container(
                        child: Text(data['course_fee']),
                      )
                    ],
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
