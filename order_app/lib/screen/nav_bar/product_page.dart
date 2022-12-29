import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
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
      // backgroundColor: Color(0xffF5EBE0),
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
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Color.fromARGB(255, 163, 201, 225),
              Color.fromARGB(255, 164, 194, 204),
              Color.fromARGB(255, 95, 131, 146),
              Color.fromARGB(255, 78, 111, 137),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 1),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Text(
                          'Product Page',
                          style: Style(30, Color(0xff0A2647), FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      productList.length.toString() + " Items ",
                      style: Style(20, Color(0xff0A2647), FontWeight.bold),
                    ),
                  ),
                ],
              ),
              productList.isEmpty
                  ? spinkit
                  : GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                          top: 10, left: 25, right: 10, bottom: 10),
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
                                        padding: EdgeInsets.all(6),
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(12),

                                          //
                                          //
                                          // DecorationImage(
                                          //     image: NetworkImage(
                                          //         "${imageUrl}${productList[index].image.toString()}"),
                                          //     fit: BoxFit.cover),

                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
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
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            ),
                                            Text(
                                              productList[index]
                                                  .name
                                                  .toString(),
                                              style: Style(
                                                  18,
                                                  Color(0xff0A2647),
                                                  FontWeight.w500),
                                            ),
                                            Text(
                                              "Quantity: " +
                                                  productList[index]
                                                      .stockItems![0]
                                                      .quantity
                                                      .toString(),
                                              style: Style(
                                                  18,
                                                  Color(0xff0A2647),
                                                  FontWeight.w500),
                                            ),
                                            Text(
                                              "Price: " +
                                                  productList[index]
                                                      .price![0]
                                                      .originalPrice
                                                      .toString(),
                                              style: Style(
                                                  18,
                                                  Color(0xff0A2647),
                                                  FontWeight.w500),
                                            ),
                                            Text(
                                              "Discount Price: " +
                                                  productList[index]
                                                      .price![0]
                                                      .discountedPrice
                                                      .toString(),
                                              style: Style(
                                                  16,
                                                  Color(0xff0A2647),
                                                  FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 70,
                                    margin: EdgeInsets.only(top: 6),
                                    padding: EdgeInsets.all(0.1),
                                    decoration: BoxDecoration(
                                      color: Color(0xff7FE9DE).withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProductPage(
                                                      productModel:
                                                          productList[index],
                                                    )))
                                            .then((value) =>
                                                Provider.of<ProductProvider>(
                                                        context,
                                                        listen: false)
                                                    .getProductData());
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Color(0xff227C70),
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
                                                id: productList[index]
                                                    .id!
                                                    .toInt());
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
            ],
          ),
        ),
      ),
    );
  }
}

Style(double? size, Color clr, [FontWeight? fw]) {
  return GoogleFonts.roboto(color: clr, fontSize: size, fontWeight: fw);
}
