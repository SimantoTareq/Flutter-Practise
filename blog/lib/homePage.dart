import 'package:blog/blog/details.dart';
import 'package:blog/blog/gallery.dart';
import 'package:blog/blog/popular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myPages = [
    Details(),
    Popular(),
    Gallery(),
  ];
  int indexpage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: myPages[indexpage],
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xffF2E5E5),
        backgroundColor: Color(0xff2B3A55).withOpacity(0.5),
        items: [
          Icon(Icons.details_sharp, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.compare_arrows, size: 30),
        ],
        onTap: (index) {
          setState(() {
            indexpage = index;
          });
        },
      ),
    );
  }
}
