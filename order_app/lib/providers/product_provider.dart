import 'package:flutter/cupertino.dart';
import 'package:order_app/custom_http/custom_http.dart';
import 'package:order_app/model/ProductModel.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> productList = [];

  getProductData() async {
    productList = await CustomeHttpRequest.getProductApi();
    notifyListeners();
  }

  deleteProductById(int index) {
    productList.removeAt(index);
    notifyListeners();
  }
}
