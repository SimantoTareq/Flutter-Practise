import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: Container(
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
        child: orderList.isEmpty
            ? spinkit
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 6),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Order Page',
                                style: Style(
                                    30, Color(0xff0A2647), FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              orderList.length.toString() + " Items ",
                              style:
                                  Style(20, Color(0xff0A2647), FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
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
                                      color: Color.fromARGB(255, 213, 213, 213)
                                          .withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Order ID: " +
                                              orderList[index].id.toString(),
                                          style: Style(18, Color(0xff0A2647),
                                              FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Name: " +
                                              orderList[index]
                                                  .user!
                                                  .name
                                                  .toString(),
                                          style: Style(18, Color(0xff0A2647),
                                              FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Price: " +
                                              orderList[index].price.toString(),
                                          style: Style(16, Color(0xff0A2647)),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: order_status == 1
                                                ? Color(0xffFED049)
                                                    .withOpacity(0.7)
                                                : order_status == 2
                                                    ? Color(0xff68B984)
                                                        .withOpacity(0.7)
                                                    : Color(0xff59C1BD)
                                                        .withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                                color: Color(0xff0A2647),
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
              ),
      ),
    );
  }
}

Style(double? size, Color clr, [FontWeight? fw]) {
  return GoogleFonts.roboto(color: clr, fontSize: size, fontWeight: fw);
}
