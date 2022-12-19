import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:order_app/model/ProductModel.dart';
import 'package:order_app/model/category_model.dart';
import 'package:order_app/screen/widget/common_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/order_model.dart';

class CustomeHttpRequest {
  static Future<Map<String, String>> getHeaderWithToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Accept": "Application/json",
      "Authorization": "bearer ${sharedPreferences.getString("token")}"
    };
    print("Saved token is ${sharedPreferences.getString("token")}");
    return header;
  }

  static Future<List<OrderModel>> fetchOrderData() async {
    List<OrderModel> orderList = [];
    OrderModel orderModel;
    var uri = "${baseUrl}all/orders";
    var responce = await http.get(Uri.parse(uri),
        headers: await CustomeHttpRequest.getHeaderWithToken());
    //print("${responce.body}");
    var data = jsonDecode(responce.body);
    for (var i in data) {
      orderModel = OrderModel.fromJson(i);
      orderList.add(orderModel);
    }
    return orderList;
  }

  static Future<List<CategoryModel>> fetchCategoryData() async {
    List<CategoryModel> categoryList = [];
    CategoryModel categoryModel;
    var uri = "${baseUrl}category";
    var responce = await http.get(Uri.parse(uri),
        headers: await CustomeHttpRequest.getHeaderWithToken());
    var data = jsonDecode(responce.body);
    print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww${data}");
    for (var i in data) {
      categoryModel = CategoryModel.fromJson(i);
      categoryList.add(categoryModel);
    }
    return categoryList;
  }

  static Future<List<ProductModel>> getProductApi() async {
    List<ProductModel> productList = [];
    String link = "${baseUrl}products";
    final response = await http.get(Uri.parse(link),
        headers: await CustomeHttpRequest.getHeaderWithToken());
    var data = jsonDecode(response.body);
    print('Product: ${data}');

    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in data) {
        productList.add(ProductModel.fromJson(i));
      }
      return productList;
    } else {
      return productList;
    }
  }
}
