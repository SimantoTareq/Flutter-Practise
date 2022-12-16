import 'package:flutter/material.dart';
import 'package:order_app/custom_http/custom_http.dart';
import 'package:order_app/model/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> orderList = [];
  getOrderData() async {
    orderList = await CustomeHttpRequest.fetchOrderData();
    notifyListeners();
  }
}
