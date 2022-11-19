import 'package:day_37/const.dart';
import 'package:day_37/custom_http.dart';
import 'package:day_37/model/news_model.dart';
import 'package:day_37/screen/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> list = <String>[
    'relevancy',
    'popularity',
    'publishedAt',
  ];

  int currentIndex = 1;
  String sortBy = "popularity";

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
            "NewsApp",
            style: myStyle(20, Color.fromARGB(255, 222, 223, 224)),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
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
                          child: Text("Prev")),
                      Flexible(
                          child: ListView.builder(
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
                                    ? Colors.blue
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
                            setState(() {
                              if (currentIndex > 1) {
                                setState(() {
                                  currentIndex = currentIndex + 1;
                                });
                              }
                            });
                          },
                          child: Text("Next"))
                    ],
                  ),
                ),
                Container(
                    height: 80,
                    child: DropdownButton<String>(
                      value: sortBy,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          sortBy = value!;
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
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
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(
                              "${snapshot.data![index].urlToImage}"),
                          title: Text("${snapshot.data![index].title}"),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
