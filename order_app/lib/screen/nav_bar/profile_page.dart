import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:order_app/providers/order_provider.dart';
import 'package:order_app/screen/auth/login_page.dart';
import 'package:order_app/screen/nav_bar/order.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profilePage extends StatefulWidget {
  const profilePage({super.key});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  @override
  Widget build(BuildContext context) {
    final orderList = Provider.of<OrderProvider>(context).orderList;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    //print(orderList.length.toString());
    int ongoing = 0;
    int complete = 0;
    int deliver = 0;
    // ListView.builder(
    //     shrinkWrap: true,
    //     itemCount: orderList.length,
    //     itemBuilder: (context, index) {
    //       var order_status =
    //           orderList[index].orderStatus!.orderStatusCategory!.id;

    //       // for (int i = 1; i <= orderList.length; i++) {
    //       //   if (order_status == 1) {
    //       //     ongoing++;
    //       //     print("object");
    //       //   } else if (order_status == 2) {
    //       //     complete++;
    //       //     print("obt");
    //       //   } else {
    //       //     deliver++;
    //       //   }
    //       // }
    //       // ;
    //       order_status == 1
    //           ? ongoing = ongoing + 1
    //           : order_status == 2
    //               ? deliver = deliver + 1
    //               : complete = complete + 1;
    //       return SizedBox();
    //     });

    return Stack(
      fit: StackFit.expand,
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              var order_status =
                  orderList[index].orderStatus!.orderStatusCategory!.id;

              // for (int i = 1; i <= orderList.length; i++) {
              //   if (order_status == 1) {
              //     ongoing++;
              //     print("object");
              //   } else if (order_status == 2) {
              //     complete++;
              //     print("obt");
              //   } else {
              //     deliver++;
              //   }
              // }
              // ;
              order_status == 1
                  ? ongoing = ongoing + 1
                  : order_status == 2
                      ? deliver = deliver + 1
                      : complete = complete + 1;

              return Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 154, 120, 84),
                ),
              );
            }),
        Scaffold(
          // backgroundColor: Color(0xffF5EBE0),
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
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.arrow_left,
                          color: Colors.white,
                        ),
                        MaterialButton(
                          onPressed: () async {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.remove("token");
                            sharedPreferences.clear();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (route) => false);
                          },
                          child: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: height * 0.5,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double innerHeight = constraints.maxHeight;
                          double innerWidth = constraints.maxWidth;
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: innerHeight * 0.72,
                                  width: innerWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 80,
                                      ),
                                      Text(
                                        'Simanto Tareq',
                                        style: Style(37, Color(0xff2C74B3),
                                            FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              Text('Ongoing',
                                                  style: Style(
                                                      20, Color(0xff0A2647))),
                                              Text(
                                                '${ongoing}',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      39, 105, 171, 1),
                                                  fontFamily: 'Nunito',
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 8,
                                            ),
                                            child: Container(
                                              height: 50,
                                              width: 3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Complete',
                                                style: Style(
                                                    20, Color(0xff0A2647)),
                                              ),
                                              Text(
                                                '${complete}',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      39, 105, 171, 1),
                                                  fontFamily: 'Nunito',
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 8,
                                            ),
                                            child: Container(
                                              height: 50,
                                              width: 3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Delivered',
                                                style: Style(
                                                    20, Color(0xff0A2647)),
                                              ),
                                              Text(
                                                '${deliver}',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      39, 105, 171, 1),
                                                  fontFamily: 'Nunito',
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 110,
                                right: 20,
                                child: Icon(
                                  Icons.settings,
                                  color: Colors.grey[700],
                                  size: 30,
                                ),
                              ),
                              Positioned(
                                top: 30,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('images/tareq.jpg'),
                                    radius: 80,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: height * 0.5,
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'My Orders',
                              style:
                                  Style(27, Color(0xff2C74B3), FontWeight.bold),
                            ),
                            Divider(
                              thickness: 2.5,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: height * 0.15,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: height * 0.15,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
