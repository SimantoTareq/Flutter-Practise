import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_app/custom_http/custom_http.dart';
import 'package:order_app/model/category_model.dart';
import 'package:order_app/providers/category_provider.dart';
import 'package:order_app/screen/widget/common_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  String? categoryType;
  TextEditingController nameController = TextEditingController();
  TextEditingController orginalPriceController = TextEditingController();
  TextEditingController discountPriceController = TextEditingController();
  TextEditingController discountTypeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  @override
  void initState() {
    Provider.of<CategoryProvider>(context, listen: false).getCategoryData();
    super.initState();
  }

  bool isLoading = true;
  uploadProduct() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
      String uriLink = "${baseUrl}product/store";
      var request = http.MultipartRequest("POST", Uri.parse(uriLink));
      request.headers.addAll(await CustomeHttpRequest.getHeaderWithToken());
      request.fields["name"] = nameController.text.toString();
      request.fields["category_id"] = categoryType.toString();
      request.fields["quantity"] = quantityController.text.toString();
      request.fields["original_price"] = orginalPriceController.text.toString();
      request.fields["discounted_price"] =
          discountPriceController.text.toString();
      request.fields["discount_type"] = "fixed";
      var photo = await http.MultipartFile.fromPath("image", image!.path);
      request.files.add(photo);
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

  List<CategoryModel> categoryList = [];
  @override
  Widget build(BuildContext context) {
    categoryList = Provider.of<CategoryProvider>(context).categoryList;
    final height = MediaQuery.of(context).size.height;
    final weidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffF5EBE0),
      appBar: AppBar(
        title: Text("Choose Category"),
        elevation: 0,
        backgroundColor: Color(0xffF5EBE0),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  decoration: BoxDecoration(
                      color: Color(0xff62B6B7),
                      border: Border.all(color: Colors.grey, width: 0.2),
                      borderRadius: BorderRadius.circular(10.0)),
                  height: 60,
                  child: Center(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 30,
                      ),
                      decoration: InputDecoration.collapsed(hintText: ''),
                      value: categoryType,
                      hint: Text(
                        'Select Category',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          categoryType = newValue;
                          print("my Category is $categoryType");

                          // print();
                        });
                      },
                      validator: (value) =>
                          value == null ? 'field required' : null,
                      items: categoryList.map((item) {
                            return DropdownMenuItem(
                              child: Text(
                                "${item.name}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              value: item.id.toString(),
                            );
                          })?.toList() ??
                          [],
                    ),
                  ),
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
                  decoration: InputDecoration(hintText: "Enter Product Price"),
                ),
                TextField(
                  controller: discountPriceController,
                  decoration: InputDecoration(hintText: "Enter Discount Price"),
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(
                  //overflow: Overflow.visible,
                  children: [
                    Container(
                      height: 150,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Color(0xff0D4C92).withOpacity(0.05),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: image == null
                          ? InkWell(
                              onTap: () {
                                getImageformGallery();
                              },
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      color: Colors.teal,
                                      size: 40,
                                    ),
                                    Text(
                                      "UPLOAD",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.teal.withOpacity(0.5)),
                                    ),
                                  ],
                                ),
                              ),
                            )
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
                                color: Color(0xff002B5B),
                                border: Border.all(
                                    color: Color(0xff002B5B), width: 1.5)),
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
                // MaterialButton(
                //   onPressed: () {
                //     uploadProduct();
                //   },
                //   child: Text("Upload"),

                // ),
                Container(
                  height: 50,
                  width: 110,
                  margin: EdgeInsets.only(top: 6),
                  padding: EdgeInsets.all(0.1),
                  decoration: BoxDecoration(
                    color: Color(0xff7FE9DE).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        uploadProduct();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff7FE9DE),
                      ),
                      child: Row(
                        children: [
                          Text("Upload"),
                          SizedBox(
                            width: 8,
                          ),
                          Icon(
                            Icons.upload,
                            color: Color(0xff66BFBF),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          )),
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
