import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:line_icons/line_icon.dart';
import 'package:order_app/custom_http/custom_http.dart';
import 'package:order_app/model/order_model.dart';
import 'package:order_app/providers/order_provider.dart';
import 'package:order_app/screen/widget/common_widget.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';

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
      backgroundColor: Color(0xffF5EBE0),
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
        backgroundColor: Color(0xffF5EBE0),
      ),
      body: orderList.isEmpty
          ? spinkit
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: orderList.length,
                      itemBuilder: (context, index) {
                        var order_status = orderList[index]
                            .orderStatus!
                            .orderStatusCategory!
                            .id;
                        return Card(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            height: 80,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text("Order id: " +
                                        orderList[index].id.toString()),
                                    Text("Name: " +
                                        orderList[index].user!.name.toString()),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("Price: " +
                                        orderList[index].price.toString()),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: order_status == 1
                                            ? Color(0xffFED049).withOpacity(0.7)
                                            : order_status == 2
                                                ? Color(0xff68B984)
                                                    .withOpacity(0.7)
                                                : Color(0xff59C1BD)
                                                    .withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(order_status == 1
                                              ? "Ongoing"
                                              : order_status == 2
                                                  ? "Delivered"
                                                  : "Complete"),
                                          Icon(
                                            order_status == 1
                                                ? LineIcons.buffer
                                                : order_status == 2
                                                    ? Icons.delivery_dining
                                                    : Icons.done_all,
                                          ),
                                        ],
                                      ),
                                    ),
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
