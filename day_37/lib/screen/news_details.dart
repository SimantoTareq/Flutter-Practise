import 'package:day_37/const.dart';
import 'package:day_37/model/news_model.dart';
import 'package:day_37/model/news_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jiffy/jiffy.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsNewsPage extends StatelessWidget {
  const DetailsNewsPage({super.key, required this.articles});
  final Articles articles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //elevation: 0,
        backgroundColor: Color.fromARGB(228, 255, 255, 255).withOpacity(0.6),
        title: Text(
          "The Guardian",
          style: GoogleFonts.lobster(
              fontSize: 25,
              color: Color(0xff121212),
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              articles.title.toString(),
              style: myStyle(20, Color(0xff121212), FontWeight.w700),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  articles.source!.name.toString(),
                  style: myStyle(
                      16, Color.fromARGB(255, 181, 106, 26), FontWeight.w700),
                ),
                Text(
                  Jiffy(articles.publishedAt.toString())
                      .format('EEE MMM dd yyy h:mm a'),
                  style: myStyle(15, Color(0xff121212), FontWeight.w400),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 9,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Image.network(articles.urlToImage.toString()),
              ),
            ),
            Text(
              articles.content.toString(),
              style: myStyle(18, Color(0xff616161), FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
