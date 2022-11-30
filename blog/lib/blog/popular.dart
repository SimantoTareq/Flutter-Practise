import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Popular extends StatefulWidget {
  const Popular({super.key});

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  Stream<QuerySnapshot> _popularStrem =
      FirebaseFirestore.instance.collection('blog').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _popularStrem,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Someting Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
            appBar: AppBar(
              title: Text("Popular Page"),
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
                  height: 500,
                  child: Card(
                    color: Color(0xff2B3A55).withOpacity(0.1),
                    elevation: 5,
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 4)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              child: Text(data['title'][0]),
                            ),
                            Text(data['title']),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.more_horiz))
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          flex: 2,
                          child: Image.network(
                            data['img'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Expanded(flex: 1, child: Text(data['des']))
                      ],
                    ),
                  ),
                );
              }).toList(),
            ));
      },
    );
  }
}
