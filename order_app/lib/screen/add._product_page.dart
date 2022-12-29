import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
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
      // backgroundColor: Color(0xffF5EBE0),
      body: Container(
          height: double.infinity,
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Choose Category",
                  style: Style(30, Color(0xff0A2647), FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
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
                        style: Style(18, Color(0xff0A2647), FontWeight.bold),
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
                                style: Style(
                                    18, Color(0xff0A2647), FontWeight.w500),
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
                  decoration: InputDecoration(
                    hintText: "Enter Product Name",
                    hintStyle: Style(18, Color(0xff0A2647), FontWeight.w500),
                  ),
                ),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    hintText: "Enter Quantty",
                    hintStyle: Style(18, Color(0xff0A2647), FontWeight.w500),
                  ),
                ),
                TextField(
                  controller: orginalPriceController,
                  decoration: InputDecoration(
                    hintText: "Enter Product Price",
                    hintStyle: Style(18, Color(0xff0A2647), FontWeight.w500),
                  ),
                ),
                TextField(
                  controller: discountPriceController,
                  decoration: InputDecoration(
                    hintText: "Enter Discount Price",
                    hintStyle: Style(18, Color(0xff0A2647), FontWeight.w500),
                  ),
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
                                      style: Style(18, Color(0xff0A2647),
                                          FontWeight.w500),
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
                  width: 126,
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
                          Text(
                            "Upload",
                            style: Style(18, Colors.white),
                          ),
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

Style(double? size, Color clr, [FontWeight? fw]) {
  return GoogleFonts.roboto(color: clr, fontSize: size, fontWeight: fw);
}
