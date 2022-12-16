import 'dart:convert';

import 'package:http/http.dart' as http;
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
}
