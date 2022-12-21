import 'package:day_37/const.dart';
import 'package:day_37/custom_http.dart';
import 'package:day_37/model/news_model.dart';
import 'package:day_37/screen/news_details.dart';
import 'package:day_37/screen/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> list = <String>[
    "relevancy",
    "popularity",
    "publishedAt",
  ];

  int currentIndex = 1;
  String sortBy = "relevancy";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.topToBottom,
                        child: SearchPage(),
                        inheritTheme: true,
                        ctx: context),
                  );
                },
                icon: Icon(Icons.search))
          ],
          title: Text(
            "The Guardian",
            style: GoogleFonts.lobster(
                fontSize: 25,
                color: Color(0xff121212),
                fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(228, 255, 255, 255).withOpacity(0.6),
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Card(
                    child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 9,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height: 28,
                        child: DropdownButton<String>(
                          value: sortBy,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xff121212),
                              fontWeight: FontWeight.bold),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              sortBy = value!;
                            });
                          },
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )),
                  ),
                ),
                FutureBuilder<List<Articles>>(
                  future: CustomeHttp()
                      .fetchAllNewsData(pageNo: currentIndex, sortBy: sortBy),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text("Something Error");
                    } else if (snapshot.data == null) {
                      return Text("No data Found ");
                    }
                    return ListView.builder(
                      padding: EdgeInsets.all(8),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsNewsPage(
                                    articles: snapshot.data![index]),
                              )),
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: Image.network(
                                    "${snapshot.data![index].urlToImage}"),
                                title: Text("${snapshot.data![index].title}"),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (currentIndex < 1) {
                        } else {
                          setState(() {
                            currentIndex = currentIndex - 1;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff616161),
                          shadowColor: Colors.grey,
                          elevation: 20),
                      child: Text("Prev")),
                  Flexible(
                      child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            currentIndex = index + 1;
                          });
                        },
                        child: Center(
                          child: Container(
                            color: index + 1 == currentIndex
                                ? Color(0xff616161)
                                : Colors.transparent,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("${index + 1}"),
                          ),
                        ),
                      );
                    },
                  )),
                  ElevatedButton(
                      onPressed: () {
                        if (currentIndex > 0) {
                          currentIndex = currentIndex + 1;
                          setState(() {});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff616161),
                          shadowColor: Colors.grey,
                          elevation: 20),
                      child: Text("Next")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
