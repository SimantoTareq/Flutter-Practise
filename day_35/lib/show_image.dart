import 'package:cached_network_image/cached_network_image.dart';
import 'package:day_35/model/model.dart';
import 'package:day_35/timer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Show_image extends StatefulWidget {
  Show_image({super.key, this.exerciseModel});
  final Exercise? exerciseModel;

  @override
  State<Show_image> createState() => _Show_imageState();
}

class _Show_imageState extends State<Show_image> {
  int second = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            imageUrl: "${widget.exerciseModel!.thumbnail}",
            placeholder: (context, url) => Image.asset("images/error.jpg"),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SleekCircularSlider(
              min: 3,
              max: 30,
              initialValue: second.toDouble(),
              onChange: (double value) {
                // callback providing a value while its being changed (with a pan gesture)
                setState(() {
                  second = value.toInt();
                });
              },
              innerWidget: (double value) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$second",
                      style: TextStyle(
                          color: Color(0xff16213E),
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print("$second");
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TimerPage(
                                  exerciseModel: widget.exerciseModel,
                                  second: second,
                                )));
                      },
                      child: Text(
                        "START",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xff9ED5C5)),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
