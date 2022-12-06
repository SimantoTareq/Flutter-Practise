import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCourse extends StatefulWidget {
  String documentId;
  String courseName;
  String courseFee;
  String img;
  UpdateCourse(this.documentId, this.courseName, this.courseFee, this.img);

  @override
  State<UpdateCourse> createState() => _UpdateCourseState();
}

class _UpdateCourseState extends State<UpdateCourse> {
  TextEditingController _courseName = TextEditingController();
  TextEditingController _courseFee = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _courseName.text = widget.courseName;
    _courseFee.text = widget.courseFee;
  }

  XFile? _courseImage;
  String? _imgUrl;

  chooseImageFromCamera() async {
    ImagePicker _picker = ImagePicker();

    _courseImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  updateData(documentId) async {
    if (_courseImage == null) {
      CollectionReference _course =
          await FirebaseFirestore.instance.collection('courses');
      _course.add(({
        'course_name': _courseName.text,
        'course_fee': _courseFee.text,
        'img': widget.img,
      }));
    } else {
      File _imageFile = File(_courseImage!.path);
      FirebaseStorage _storage = await FirebaseStorage.instance;

      UploadTask _uploadTask =
          _storage.ref('courses').child(_courseImage!.name).putFile(_imageFile);

      TaskSnapshot _snapshot = await _uploadTask;
      _imgUrl = await _snapshot.ref.getDownloadURL();
      CollectionReference _course =
          await FirebaseFirestore.instance.collection('courses');
      _course.add(({
        'course_name': _courseName.text,
        'course_fee': _courseFee.text,
        'img': _imgUrl,
      }));
      _courseName.clear();
      _courseFee.clear();
    }
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
                    ? Stack(
                        children: [
                          Image.network(
                            widget.img,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                              child: CircleAvatar(
                            child: IconButton(
                                onPressed: () {
                                  chooseImageFromCamera();
                                },
                                icon: Icon(Icons.camera)),
                          ))
                        ],
                      )
                    : Image.file(File(_courseImage!.path))),
            ElevatedButton(
                onPressed: () {
                  updateData(widget.documentId);
                },
                child: Text('Update Course'))
          ],
        ),
      ),
    );
  }
}
