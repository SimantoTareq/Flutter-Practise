import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  Stream<QuerySnapshot> _galleryrStrem =
      FirebaseFirestore.instance.collection('blog').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _galleryrStrem,
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
          backgroundColor: Color(0xff2B3A55).withOpacity(0.5),
          appBar: AppBar(
            title: Text("Gallery Page"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(6),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Container(
                  color: Color(0xff2B3A55).withOpacity(0.5),
                  padding: EdgeInsets.fromLTRB(20, 10, 0, 4),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Image.network(
                          data['img'],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Expanded(flex: 2, child: Text(data['title']))
                    ],
                  ));
            }).toList(),
          ),
        );
      },
    );
  }
}
