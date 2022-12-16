import 'package:flutter/cupertino.dart';
import 'package:order_app/custom_http/custom_http.dart';

import '../model/category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> categoryList = [];
  getCategoryData() async {
    categoryList = await CustomeHttpRequest.fetchCategoryData();
    notifyListeners();
  }
}
