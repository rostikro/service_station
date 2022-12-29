import 'package:flutter/material.dart';
import 'package:service_station/screens/work_tile.dart';
import 'package:service_station/models/work_model.dart';

class WorkList extends StatelessWidget {
  const WorkList({Key? key, required this.works}) : super(key: key);
  final List<Work> works;

  @override
  Widget build(BuildContext context) {
    if (works.length == 0) {
      return Center(child: Text('Click on the settings button to add a new work.'));
    } else {
      return ListView.separated(
        itemCount: works.length,
        itemBuilder: (context, index) {
          return WorkTile(works: works[index], mode: 1);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      );
    }
  }
}
