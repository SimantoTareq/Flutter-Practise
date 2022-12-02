import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class addCourse extends StatefulWidget {
  const addCourse({super.key});

  @override
  State<addCourse> createState() => _addCourseState();
}

class _addCourseState extends State<addCourse> {
  TextEditingController _courseName = TextEditingController();
  TextEditingController _courseFee = TextEditingController();
  XFile? _courseImage;
  String? _imgUrl;

  chooseImageFromCamera() async {
    ImagePicker _picker = ImagePicker();

    _courseImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  sendData() async {
    File _imageFile = File(_courseImage!.path);
    FirebaseStorage _storage = await FirebaseStorage.instance;

    UploadTask _uploadTask =
        _storage.ref('courses').child(_courseImage!.name).putFile(_imageFile);

    TaskSnapshot _snapshot = await _uploadTask;
    _imgUrl = await _snapshot.ref.getDownloadURL();

    CollectionReference _course =
        FirebaseFirestore.instance.collection('courses');
    _course.add(({
      'course_name': _courseName.text,
      'course_fee': _courseFee.text,
      'img': _imgUrl,
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _courseName,
              decoration: InputDecoration(
                  hintText: "Add new course",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _courseFee,
              decoration: InputDecoration(
                  hintText: "Add new fee",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: _courseImage == null
                    ? IconButton(
                        onPressed: () {
                          chooseImageFromCamera();
                        },
                        icon: Icon(Icons.camera),
                      )
                    : Image.file(File(_courseImage!.path))),
            ElevatedButton(
                onPressed: () {
                  sendData();
                },
                child: Text('Add Course'))
          ],
        ),
      ),
    );
  }
}
