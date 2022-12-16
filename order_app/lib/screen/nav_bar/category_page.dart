import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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

  @override
  Widget build(BuildContext context) {
    final categoryList = Provider.of<CategoryProvider>(context).categoryList;
    return Scaffold(
      body: SingleChildScrollView(
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: categoryList.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 23, crossAxisSpacing: 20),
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                child: Image.network("${imageUrl}${categoryList[index].image}"),
              );
            }),
      ),
    );
  }
}
