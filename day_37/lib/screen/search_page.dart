import 'package:day_37/custom_http.dart';
import 'package:day_37/model/news_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController Searchcontroller = TextEditingController();
  List<Articles> searchList = [];
  FocusNode focusNode = FocusNode();
  List<String> searchKeyword = [
    "World",
    "Sports",
    "Politics",
    "Fashion",
    "Entertainment",
  ];
  bool isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    Searchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading == true,
      blur: 0.5,
      opacity: 0.5,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.all(22),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 60,
                    child: TextField(
                      focusNode: focusNode,
                      controller: Searchcontroller,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                searchList = [];
                                Searchcontroller.clear();
                                setState(() {});
                              },
                              icon: Icon(Icons.close))),
                      onEditingComplete: () async {
                        searchList = await CustomeHttp().fetchSearchData(
                            query: Searchcontroller.text.toString());
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: MasonryGridView.count(
                      itemCount: searchKeyword.length,
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            Searchcontroller.text = searchKeyword[index];
                            searchList = await CustomeHttp()
                                .fetchSearchData(query: searchKeyword[index]);
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: Text("${searchKeyword[index]}"),
                        );
                      },
                    ),
                  ),
                  searchList.isNotEmpty
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: searchList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Image.network(
                                  "${searchList[index].urlToImage}"),
                              title: Text("${searchList[index].title}"),
                            );
                          },
                        )
                      : SizedBox(
                          height: 0,
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
