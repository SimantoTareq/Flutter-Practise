import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:order_app/providers/product_provider.dart';
import 'package:order_app/screen/add._product_page.dart';
import 'package:order_app/screen/widget/common_widget.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class productPage extends StatefulWidget {
  const productPage({super.key});

  @override
  State<productPage> createState() => _productPageState();
}

class _productPageState extends State<productPage> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<ProductProvider>(context, listen: false).getProductData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productList = Provider.of<ProductProvider>(context).productList;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddProductPage()))
              .then((value) =>
                  Provider.of<ProductProvider>(context, listen: false)
                      .getProductData());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Product",
          style: TextStyle(color: Colors.white, fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: productList.isEmpty
          ? spinkit
          : GridView.builder(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              shrinkWrap: true,
              itemCount: productList.length,
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
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),

                              //
                              //
                              // DecorationImage(
                              //     image: NetworkImage(
                              //         "${imageUrl}${productList[index].image.toString()}"),
                              //     fit: BoxFit.cover),
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${imageUrl}${productList[index].image.toString()}",
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        productList[index].name.toString(),
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Quantity: " +
                            productList[index]
                                .stockItems![0]
                                .quantity
                                .toString(),
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Price: " +
                            productList[index]
                                .price![0]
                                .originalPrice
                                .toString(),
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Discount Price: " +
                            productList[index]
                                .price![0]
                                .discountedPrice
                                .toString(),
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                );
              }),
    );
  }
}
