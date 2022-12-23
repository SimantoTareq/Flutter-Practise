import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_app/custom_http/custom_http.dart';
import 'package:order_app/model/ProductModel.dart';
import 'package:order_app/screen/widget/common_widget.dart';
import 'package:http/http.dart' as http;

class EditProductPage extends StatefulWidget {
  ProductModel? productModel;
  EditProductPage({super.key, required this.productModel});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  String? categoryType;
  TextEditingController? nameController;
  TextEditingController? orginalPriceController;
  TextEditingController? discountPriceController;

  TextEditingController? quantityController;
  @override
  void initState() {
    nameController = TextEditingController(text: widget.productModel!.name);
    quantityController = TextEditingController(
        text: widget.productModel!.stockItems![0].quantity.toString());
    orginalPriceController = TextEditingController(
        text: widget.productModel!.price![0].originalPrice.toString());
    discountPriceController = TextEditingController(
        text: widget.productModel!.price![0].discountedPrice.toString());

    // TODO: implement initState
    super.initState();
  }

  bool isLoading = true;
  updateProduct() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
      String uriLink = "${baseUrl}/${widget.productModel!.id}/update";
      var request = http.MultipartRequest("POST", Uri.parse(uriLink));
      request.headers.addAll(await CustomeHttpRequest.getHeaderWithToken());
      request.fields["name"] = nameController!.text.toString();
      // request.fields["category_id"] = categoryType.toString();
      request.fields["quantity"] = quantityController!.text.toString();
      request.fields["original_price"] =
          orginalPriceController!.text.toString();
      request.fields["discounted_price"] =
          discountPriceController!.text.toString();
      request.fields["discount_type"] = "fixed";
      if (image != null) {
        var photo = await http.MultipartFile.fromPath("image", image!.path);
        request.files.add(photo);
      }
      var responce = await request.send();
      var responceData = await responce.stream.toBytes();
      var responceString = String.fromCharCodes(responceData);
      print("responce bodyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy ${responceString}");
      print(
          "Status code issss${responce.statusCode} ${request.fields} ${request.files.toString()}");
      if (responce.statusCode == 201) {
        showInToast("Product Uploaded Succesfully");

        Navigator.of(context).pop();
      } else {
        showInToast("Something wrong, try again plz bro");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final weidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    //overflow: Overflow.visible,
                    children: [
                      Container(
                        height: 150,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: image == null
                            ? InkWell(
                                onTap: () {
                                  getImageformGallery();
                                },
                                child: Image.network(
                                    "${imageUrl}${widget.productModel!.image}"))
                            : Container(
                                height: 150,
                                width: 200,
                                child: Image.file(image!),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: weidth * 0.4,
                        child: Visibility(
                          child: TextButton(
                            onPressed: () {
                              getImageformGallery();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  color: Colors.black,
                                  border: Border.all(
                                      color: Colors.black, width: 1.5)),
                              child: Center(
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  child: Icon(Icons.edit),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: "Enter Product Name"),
                  ),
                  TextField(
                    controller: quantityController,
                    decoration: InputDecoration(hintText: "Enter Quantty"),
                  ),
                  TextField(
                    controller: orginalPriceController,
                    decoration:
                        InputDecoration(hintText: "Enter Product Price"),
                  ),
                  TextField(
                    controller: discountPriceController,
                    decoration:
                        InputDecoration(hintText: "Enter Discount Price"),
                  ),
                  MaterialButton(
                    onPressed: () {
                      updateProduct();
                    },
                    child: Text("Upload"),
                  )
                ],
              ),
            )),
      ),
    );
  }

  File? image;
  final picker = ImagePicker();

  Future getImageformGallery() async {
    print('on the way of gallery');
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
        print('image found');
        print('${image!.path}');
      } else {
        print('no image found');
      }
    });
  }
}
