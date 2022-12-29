import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:service_station/database/database.dart';
import 'package:service_station/other/dialogues.dart';
import 'package:service_station/screens/work_tile.dart';

import '../models/work_model.dart';

class EditWork extends StatelessWidget {
  List<Work> works = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit work')),
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
                  imageDownloadUrl: work['imageDownloadUrl']);
            }).toList();

            if (works.length == 0) {
              return Center(child: Text('Click on the + button to add a new job.'));
            }
            else {
              return ListView.separated(
                itemCount: works.length,
                itemBuilder: (context, index) {
                  return WorkTile(works: works[index], mode: 2);
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Dialogues.addWorkDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
