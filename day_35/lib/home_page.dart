import 'dart:convert';

import 'package:day_35/model/model.dart';
import 'package:day_35/show_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String link =
      "https://raw.githubusercontent.com/codeifitech/fitness-app/master/exercises.json?fbclid=IwAR1k6u_TREfKtEIFhvcoM--WsByKZzLtQci48vound6ezkivlWdZn0OaZLM";
  List<Exercise> alldata = [];
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
            alldata.add(exerciseModel);
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
      progressIndicator: spinkit,
      child: Scaffold(
        backgroundColor: Color(0xffA9B7FF),
        body: ListView.builder(
          itemCount: alldata.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Show_image(
                          exerciseModel: alldata[index],
                        )));
              },
              child: Container(
                padding: EdgeInsets.all(8),
                height: 180,
                width: double.infinity,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: "${alldata[index].thumbnail}",
                        placeholder: (context, url) =>
                            Image.asset("images/error.jpg"),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${alldata[index]}",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${alldata[index].seconds} Sec",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffEFF5F5)),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 184, 190, 195),
                                  Color.fromARGB(197, 59, 59, 59),
                                  Colors.transparent
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter)),
                      ),
                    )
                  ],
                ),
              ),
            );
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

const spinkit = SpinKitSpinningLines(
  color: Color.fromARGB(255, 24, 23, 23),
  size: 50.0,
);
