import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_app/providers/category_provider.dart';
import 'package:order_app/screen/widget/common_widget.dart';
import 'package:provider/provider.dart';

class category_page extends StatefulWidget {
  const category_page({super.key});

  @override
  State<category_page> createState() => _category_pageState();
}

class _category_pageState extends State<category_page> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<CategoryProvider>(context, listen: false).getCategoryData();

    super.initState();
  }

  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final categoryList = Provider.of<CategoryProvider>(context).categoryList;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 6),
          color: Color(0xffF5EBE0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Category Page',
                      style: Style(30, Color(0xff0A2647), FontWeight.bold),
                    ),
                    Container(
                        color: Color.fromARGB(255, 238, 229, 203),
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.category,
                          color: Color(0xff0A2647),
                        )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: Container(
                          color: Colors.white,
                          width: 50,
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.search),
                              hintText: 'Search Product',
                              hintStyle: Style(
                                16,
                                Color(0xff0A2647),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: Style(24, Color(0xff0A2647), FontWeight.bold),
                    ),
                    Text(
                      'See All',
                      style: Style(14, Color(0xff0A2647), FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Container(
                    height: 50,
                    color: Color(0xffF5EBE0),
                    child: ListView.builder(
                        //padding: EdgeInsets.all(10),
                        itemCount: categoryList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(width: .7),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(2.5),
                              margin: EdgeInsets.fromLTRB(4, 2, 4, 2),
                              // color: Color.fromARGB(255, 255, 255, 255),
                              width: 80,
                              height: 60,
                              child: Column(
                                children: [
                                  Text(
                                    categoryList[index].name.toString(),
                                    style: Style(
                                      14,
                                      Color(0xff0A2647),
                                    ),
                                  ),
                                ],
                              ));
                        })),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trending Product',
                      style: Style(24, Color(0xff0A2647), FontWeight.bold),
                    ),
                    Text(
                      'See All',
                      style: Style(14, Color(0xff0A2647), FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                        top: 10, left: 25, right: 10, bottom: 10),
                    shrinkWrap: true,
                    itemCount: categoryList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.7,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0),
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      height: 200,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Product ID: " +
                                                categoryList[index]
                                                    .id
                                                    .toString(),
                                            style: Style(18, Color(0xff0A2647),
                                                FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Image.network(
                                              "${imageUrl}${categoryList[index].image}"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Style(double? size, Color clr, [FontWeight? fw]) {
  return GoogleFonts.roboto(color: clr, fontSize: size, fontWeight: fw);
}
