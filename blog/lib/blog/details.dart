import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Stream<QuerySnapshot> _detailsStream =
      FirebaseFirestore.instance.collection('blog').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _detailsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('something error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Details Page"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Container(
                color: Color(0xff2B3A55).withOpacity(0.5),
                padding: EdgeInsets.symmetric(vertical: 5),
                height: 350,
                child: Card(
                  color: Color(0xff2B3A55).withOpacity(0.1),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            child: ClipRRect(
                              child: Image.network(
                                data['img'],
                                height: MediaQuery.of(context).size.height,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  data['title'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  data['des'],
                                  maxLines: 10,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  customDialog(
                                      data['img'], data['title'], data['des']);
                                },
                                child: Container(
                                  child: Text(
                                    'View Details',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  margin: EdgeInsets.all(25),
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Color(0xffEFEFEF),
                                      borderRadius:
                                          BorderRadius.circular(25.0)),
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  customDialog(String img, String title, String des) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Color(0xffB2B2B2).withOpacity(0.8),
            child: Container(
              padding: EdgeInsets.all(20),
              height: 550,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      child: Image.network(
                        img,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(title),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        des,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
