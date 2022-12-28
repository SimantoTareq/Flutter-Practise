import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:order_app/custom_http/custom_http.dart';
import 'package:order_app/model/ProductModel.dart';
import 'package:order_app/screen/widget/common_widget.dart';
import 'package:http/http.dart' as http;

class EditProductPage extends StatefulWidget {
  ProductModel? productModel;
  EditProductPage({Key? key, required this.productModel}) : super(key: key);

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  TextEditingController? nameController;
  TextEditingController? quantityController;
  TextEditingController? originalPriceController;
  TextEditingController? discountPriceController;

  @override
  void initState() {
    // TODO: implement initState
    nameController = TextEditingController(text: widget.productModel!.name);
    quantityController = TextEditingController(
        text: widget.productModel!.stockItems![0].quantity.toString());
    originalPriceController = TextEditingController(
        text: widget.productModel!.price![0].originalPrice.toString());
    discountPriceController = TextEditingController(
        text: widget.productModel!.price![0].discountedPrice.toString());
    super.initState();
  }

  bool isLoading = false;
  updateProduct() async {
    try {
      setState(() {
        isLoading = true;
      });
      showInToast("Uploading");
      var uriLink = "${baseUrl}product/${widget.productModel!.id}/update";
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(uriLink),
      );
      request.headers.addAll(await CustomeHttpRequest.getHeaderWithToken());
      request.fields["name"] = nameController!.text.toString();
      request.fields["category_id"] =
          widget.productModel!.foodItemCategory![0].id.toString();
      request.fields["quantity"] = quantityController!.text.toString();
      request.fields["original_price"] =
          originalPriceController!.text.toString();
      request.fields["discounted_price"] =
          discountPriceController!.text.toString();
      request.fields["discount_type"] = "fixed";
      if (image != null) {
        request.files
            .add(await http.MultipartFile.fromPath("image", image!.path));
      }
      var responce = await request.send();
      setState(() {
        isLoading = false;
      });
      var responceData = await responce.stream.toBytes();
      var responceString = String.fromCharCodes(responceData);
      print(
          "Status code issssssssssssssss${responce.statusCode} ${responceString}");
      if (responce.statusCode == 200) {
        showInToast("Product Uploaded succesfully");
        Navigator.of(context).pop();
      } else {
        showInToast("Something Wrong");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showInToast("Something wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading == true,
      blur: 0.5,
      opacity: 0.5,
      child: Scaffold(
        backgroundColor: Color(0xffF5EBE0),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Choose Category"),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: "Enter Product Name"),
                ),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(hintText: "Enter Quantity"),
                ),
                TextField(
                  controller: originalPriceController,
                  decoration: InputDecoration(hintText: "Enter Product Price"),
                ),
                TextField(
                  controller: discountPriceController,
                  decoration: InputDecoration(hintText: "Enter Discount Price"),
                ),
                SizedBox(
                  height: 30,
                ),
                Stack(
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
                      left: 0,
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
                              border:
                                  Border.all(color: Colors.black, width: 1.5)),
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
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  color: Colors.teal,
                  onPressed: () {
                    updateProduct();
                    //   uploadProduct();
                  },
                  child: Text("Upload Productt"),
                )
              ],
            ),
          ),
        ),
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
