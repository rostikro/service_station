import 'package:flutter/material.dart';
import 'package:service_station/models/work_model.dart';
import 'package:service_station/models/cart_model.dart';
import 'package:provider/provider.dart';
import 'package:service_station/other/dialogues.dart';

class WorkTile extends StatefulWidget {
  final Work works;
  final int mode;

  const WorkTile({required this.works, required this.mode});

  @override
  _WorkTileState createState() => _WorkTileState();
}

class _WorkTileState extends State<WorkTile> {
  bool isCheck = false;

  Widget formatTime() {
    if (widget.works.time == 0.5) {
      return Text('Time: 30 min');
    } else {
      return Text('Time: ' + widget.works.time.toString() + ' h');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == 0) {
      return ListTile(
          title: Text(widget.works.title),
          subtitle: formatTime(),
          leading:
          Image.network(widget.works.imageDownloadUrl, width: 45, height: 45),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.works.price.toString() + ' PLN'),
            ],
          ));
    } else if (widget.mode == 1) {
      return ListTile(
          title: Text(widget.works.title),
          subtitle: formatTime(),
          leading:
            Image.network(widget.works.imageDownloadUrl, width: 45, height: 45),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.works.price.toString() + ' PLN'),
              Checkbox(
                  value: isCheck,
                  onChanged: (bool? state) async {
                    if (state == true) {
                      final detailPrice = await Dialogues.detailsPriceDialog(context);
                      if (detailPrice == null || detailPrice == "") return;

                      widget.works.detailPrice = int.parse(detailPrice);
                    }
                    setState(() {
                      isCheck = state!;
                      var cart = context.read<Cart>();
                      if (state == true) {
                        cart.add(widget.works);
                      } else {
                        cart.remove(widget.works);
                      }
                    });
                  })
            ],
          ));
    } else {
      return ListTile(
          title: Text(widget.works.title),
          subtitle: formatTime(),
          leading:
          Image.network(widget.works.imageDownloadUrl, width: 45, height: 45),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.works.price.toString() + ' PLN'),
              IconButton(
                  onPressed: () {
                    Dialogues.editWorkDialog(context, widget.works);
                  },
                  icon: Icon(Icons.edit, color: Colors.blue)),
              IconButton(
                  onPressed: () {
                    Dialogues.deleteWorkDialog(context, widget.works.uid, widget.works.image);
                  },
                  icon: Icon(Icons.delete, color: Colors.red)),
            ],
          ));
    }
  }
}
