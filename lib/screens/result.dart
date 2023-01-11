import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_station/screens/work_tile.dart';
import 'package:service_station/models/work_model.dart';
import 'package:service_station/models/cart_model.dart';
import 'package:provider/provider.dart';

class ResultForm extends StatelessWidget {
  List<String> countTotal(List<Work> works) {
    int price = 0;
    int detailsCost = 0;
    double totalTime = 0;
    for (int i = 0; i < works.length; i++) {
      price += works[i].price + works[i].detailPrice;
      detailsCost += works[i].detailPrice;
      totalTime += works[i].time;
    }

    List<String> result = [];
    result.add(price.toString());
    result.add(detailsCost.toString());
    if (totalTime == 0.5)
      result.add('30 min');
    else
      result.add(totalTime.toString() + ' h');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<Cart>();

    List<String> works = countTotal(cart.works);

    return Scaffold(
        appBar: AppBar(title: Text('Result')),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Column(
            children: [
              Expanded(
                  child: ListView.separated(
                itemCount: cart.works.length,
                itemBuilder: (context, index) {
                  return WorkTile(works: cart.works[index], mode: 0);
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              )),
              Divider(height: 50, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('TOTAL',
                      style: TextStyle(fontSize: 20.0, color: Colors.grey)),
                  Spacer(),
                  Text(works[0] + ' USD', style: TextStyle(fontSize: 20.0))
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Details price'),
                  Spacer(),
                  Text(works[1] + ' USD', style: TextStyle(color: Colors.grey))
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Total time'),
                  Spacer(),
                  Text(works[2], style: TextStyle(color: Colors.grey))
                ],
              ),
              SizedBox(height: 30)
            ],
          ),
        ));
  }
}
