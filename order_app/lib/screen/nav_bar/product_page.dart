import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:order_app/custom_http/custom_http.dart';
import 'package:order_app/providers/product_provider.dart';
import 'package:order_app/screen/add._product_page.dart';
import 'package:order_app/screen/edit_product_page.dart';
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
      backgroundColor: Color(0xffF5EBE0),
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              child: Icon(
                Icons.arrow_back_outlined,
                color: Colors.black,
              ),
              alignment: Alignment.topLeft,
            ),
            Align(
              child: Text(
                "Product List",
                style: TextStyle(color: Colors.black),
              ),
              alignment: Alignment.topLeft,
            ),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              productList.length.toString() + "Items ",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Color(0xffF5EBE0),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xff2C74B3),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddProductPage()))
              .then((value) =>
                  Provider.of<ProductProvider>(context, listen: false)
                      .getProductData());
        },
        icon: Icon(Icons.add),
        label: Text("Add Product"),
      ),
      body: productList.isEmpty
          ? spinkit
          : GridView.builder(
              padding:
                  EdgeInsets.only(top: 10, left: 25, right: 10, bottom: 10),
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
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(12),

                                  //
                                  //
                                  // DecorationImage(
                                  //     image: NetworkImage(
                                  //         "${imageUrl}${productList[index].image.toString()}"),
                                  //     fit: BoxFit.cover),

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
                                child: Column(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          "${imageUrl}${productList[index].image.toString()}",
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      productList[index].name.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "Quantity: " +
                                          productList[index]
                                              .stockItems![0]
                                              .quantity
                                              .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "Price: " +
                                          productList[index]
                                              .price![0]
                                              .originalPrice
                                              .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "Discount Price: " +
                                          productList[index]
                                              .price![0]
                                              .discountedPrice
                                              .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 70,
                            margin: EdgeInsets.only(top: 6),
                            padding: EdgeInsets.all(0.1),
                            decoration: BoxDecoration(
                              color: Color(0xff7FE9DE).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => EditProductPage(
                                              productModel: productList[index],
                                            )))
                                    .then((value) =>
                                        Provider.of<ProductProvider>(context,
                                                listen: false)
                                            .getProductData());
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Color(0xff66BFBF),
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 70,
                            margin: EdgeInsets.fromLTRB(0, 6, 16, 0),
                            padding: EdgeInsets.all(0.1),
                            decoration: BoxDecoration(
                              color: Color(0xffD61C4E).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                var result = await CustomeHttpRequest()
                                    .deleteProduct(
                                        id: productList[index].id!.toInt());
                                print("Result is ${result}");
                                if (result["error"] != null) {
                                  showInToast("${result["error"]}");
                                } else {
                                  showInToast("${result["message"]}");
                                  Provider.of<ProductProvider>(context,
                                          listen: false)
                                      .deleteProductById(index);
                                }
                              },
                              icon: Center(
                                child: Icon(
                                  Icons.delete,
                                  color: Color(0xffEB1D36),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
    );
  }
}
