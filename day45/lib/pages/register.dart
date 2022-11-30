import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  Future addUser() async {
    CollectionReference _users =
        await FirebaseFirestore.instance.collection("register");
    _users.add(({
      'name': _nameController.text,
      'phone': _phoneController.text,
      'age': _ageController.text,
      'address': _addressController.text,
    }));
    _nameController.clear();
    _phoneController.clear();
    _addressController.clear();
    _ageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: "Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                      hintText: "Phone",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                      hintText: "Address",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: _ageController,
                  decoration: InputDecoration(
                      hintText: "Age",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      addUser();
                    },
                    child: Text("Registration Now"))
              ],
            ),
          ),
        ));
  }
}
