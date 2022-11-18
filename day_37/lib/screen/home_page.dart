import 'package:day_37/const.dart';
import 'package:day_37/custom_http.dart';
import 'package:day_37/model/news_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageNo = 1;
  String sortBy = "popularity";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        title: Text(
          "NewsApp",
          style: myStyle(20, Color.fromARGB(255, 222, 223, 224)),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 80,
                color: Colors.red,
              ),
              Container(
                height: 80,
              ),
              FutureBuilder<List<Articles>>(
                future: CustomeHttp()
                    .fetchAllNewsData(pageNo: pageNo, sortBy: sortBy),
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
    );
  }
}
