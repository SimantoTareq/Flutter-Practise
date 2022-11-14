import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:day_35/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TimerPage extends StatefulWidget {
  TimerPage({super.key, this.exerciseModel, this.second});
  final Exercise? exerciseModel;
  final int? second;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late Timer timer;
  int startCount = 1;

  @override
  void initState() {
    // TODO: implement initState
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timer.tick == widget.second) {
        timer.cancel();
        Future.delayed(
          Duration(seconds: 2),
          () {
            Navigator.of(context).pop();
          },
        );
      }
      setState(() {
        startCount = timer.tick;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            height: double.infinity,
            imageUrl: "${widget.exerciseModel!.gif}",
            placeholder: (context, url) => Image.asset("images/error.jpg"),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Positioned(
              top: 80,
              right: 30,
              left: 20,
              child: Center(
                  child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Color(0xffA0E4CB),
                    borderRadius: BorderRadius.circular(40)),
                child: Text(
                  timer.tick == widget.second ? "Done" : "${startCount}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ))),
        ],
      ),
    );
  }
}
