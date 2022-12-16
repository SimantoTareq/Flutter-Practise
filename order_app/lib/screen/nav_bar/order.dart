import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:order_app/custom_http/custom_http.dart';
import 'package:order_app/model/order_model.dart';
import 'package:order_app/providers/order_provider.dart';
import 'package:order_app/screen/widget/common_widget.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    Provider.of<OrderProvider>(context, listen: false).getOrderData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderList = Provider.of<OrderProvider>(context).orderList;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              child: Icon(
                Icons.arrow_back_outlined,
                color: Colors.black,
              ),
              alignment: Alignment.topLeft,
            ),
            Align(
              child: Text(
                "Order List",
                style: TextStyle(color: Colors.black),
              ),
              alignment: Alignment.topLeft,
            ),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              orderList.length.toString() + "Items ",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.grey[200],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Order id: " + orderList[index].id.toString()),
                          Column(
                            children: [
                              Text("Name: " +
                                  orderList[index].user!.name.toString()),
                              Text("Price: " +
                                  orderList[index].price.toString()),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
