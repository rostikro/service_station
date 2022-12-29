import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:service_station/models/work_model.dart';
import 'package:service_station/models/cart_model.dart';
import 'package:service_station/screens/edit_work.dart';
import 'package:service_station/screens/work_list.dart';
import 'package:service_station/screens/result.dart';

import '../database/database.dart';

class WorkScreen extends StatelessWidget {
  WorkScreen({Key? key}) : super(key: key);

  final String title = 'Service Station';
  final Cart cart = Cart();
  List<Work> works = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditWork()));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: StreamBuilder(
          stream: Database.readWorks(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            works = snapshot.data!.docs.map((work) {
              return Work(
                  uid: work.id,
                  title: work['name'],
                  price: work['price'],
                  time: work['time'].toDouble(),
                  image: work['image'],
                imageDownloadUrl: work['imageDownloadUrl']
              );
            }).toList();
            return WorkList(works: works);
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ResultForm()));
          },
          child: const Icon(Icons.calculate)),
    );
  }
}
