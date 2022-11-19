import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:day_37/const.dart';
import 'package:day_37/model/news_model.dart';
import 'package:http/http.dart ' as http;

class CustomeHttp {
  Future<List<Articles>> fetchAllNewsData(
      {required int pageNo, required String sortBy}) async {
    List<Articles> allNewsData = [];
    Articles articles;

    var responce = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=bitcoin&page=$pageNo&pageSize=10&sortBy=$sortBy&apiKey=6f216ebce676448a8e7a27baa4b1f235"));
    print("responce is ${responce.body}");

    var data = jsonDecode(responce.body);
    for (var i in data["articles"]) {
      articles = Articles.fromJson(i);
      allNewsData.add(articles);
    }

    return allNewsData;
  }

  Future<List<Articles>> fetchSearchData({required String query}) async {
    List<Articles> allNewsData = [];
    Articles articles;

    var responce = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=$query&pageSize=10&apiKey=6f216ebce676448a8e7a27baa4b1f235"));
    print("responce is ${responce.body}");

    var data = jsonDecode(responce.body);
    for (var i in data["articles"]) {
      articles = Articles.fromJson(i);
      allNewsData.add(articles);
    }

    return allNewsData;
  }
}
