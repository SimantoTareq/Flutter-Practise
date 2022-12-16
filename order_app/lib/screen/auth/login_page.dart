import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:order_app/screen/nav_bar/order.dart';
import 'package:order_app/screen/widget/common_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  clearText() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  getLogin() async {
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var link = "${baseUrl}sign-in";
      var map = Map<String, dynamic>();
      map["email"] = emailController.text.toString();
      map["password"] = passwordController.text.toString();
      var responce = await http.post(Uri.parse(link), body: map);
      var data = jsonDecode(responce.body);
      setState(() {
        isLoading = false;
      });

      // print("Show ${responce.body}");
      //print("Access token is ${data["access_token"]}");
      if (data["access_token"] != null) {
        sharedPreferences.setString("token", data["access_token"]);
        // print("Result is ${sharedPreferences.getString("token")}");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => OrderPage()),
            (route) => false);
      } else {
        showInToast("Email or password is not match");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading == true,
      blur: 0.5,
      opacity: 0.5,
      child: SafeArea(
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      autofocus: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Email",
                        labelStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        errorStyle:
                            TextStyle(color: Colors.red, fontSize: 15.0),
                      ),
                      controller: emailController,
                      validator: (value) {
                        var emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value.toString());

                        if (value!.isEmpty) {
                          return "Fill up with your email";
                        }
                        if (emailValid == false) {
                          return "Invalid email";
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      autofocus: false,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        labelText: "Password",
                        labelStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorStyle:
                            TextStyle(color: Colors.red, fontSize: 15.0),
                      ),
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      Text(
                        'Forget Password?',
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  getLogin();
                                } else {
                                  showInToast("Please  Enter all fields");
                                }
                              },
                              child: Text("Login"),
                            ),
                            ElevatedButton(
                              onPressed: () => {clearText()},
                              child: Text("Reset"),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Does not have account? '),
                          InkWell(
                              child: Text(
                            'Sing In',
                            style: TextStyle(color: Colors.blue),
                          ))
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
