import 'dart:convert';

import 'package:api/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String link =
      "https://raw.githubusercontent.com/codeifitech/fitness-app/master/exercises.json?fbclid=IwAR1k6u_TREfKtEIFhvcoM--WsByKZzLtQci48vound6ezkivlWdZn0OaZLM";
  List<Exercise> alldate = [];
  late Exercise exerciseModel;
  bool isLoading = false;

  fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var responce = await http.get(Uri.parse(link));
      print("Our responce is ${responce.body}");
      if (responce.statusCode == 200) {
        var data = jsonDecode(responce.body)["exercises"];
        for (var i in data) {
          exerciseModel = Exercise(
              title: i['title'],
              seconds: i['seconds'],
              id: i['id'],
              gif: i['gif'],
              thumbnail: i['thumbnail']);
          setState(() {
            alldate.add(exerciseModel);
          });
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      showToast("Something Wrong");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading == true,
      blur: 0.5,
      opacity: 0.5,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
        body: ListView.builder(
          itemCount: alldate.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
                child: Card(
              color: Color(0xffFEFBF6).withOpacity(0.9),
              child: ListTile(
                leading: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text("${alldate[index].id}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                title: Image(
                  image: NetworkImage("${alldate[index].thumbnail}"),
                  height: 100,
                  width: 50,
                  alignment: Alignment.topLeft,
                ),
                subtitle: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "${alldate[index].title}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                trailing: Image(image: NetworkImage("${alldate[index].gif}")),
                contentPadding: EdgeInsets.all(20),
              ),
            ));
          },
        ),
      ),
    );
  }
}

showToast(String title) {
  return Fluttertoast.showToast(
      msg: "$title",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
