import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:service_station/widgets/edit_image.dart';

import '../database/database.dart';
import '../models/work_model.dart';

class Dialogues {
  static TextEditingController detailPrice = TextEditingController();
  static TextEditingController title = TextEditingController();
  static TextEditingController price = TextEditingController();
  static TextEditingController time = TextEditingController();

  static PlatformFile? file;

  static Future<String?> detailsPriceDialog(BuildContext context) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Detail Price'),
                content: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Detail price',
                      icon: Icon(Icons.monetization_on, color: Colors.black54),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.blue))),
                  controller: detailPrice,
                  onSubmitted: (_) => submitDetailPrice(context),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text('OK'),
                    onPressed: () => submitDetailPrice(context),
                  )
                ],
              ));

  static void submitDetailPrice(BuildContext context) {
    if (detailPrice.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter detail price!')));
    }
    Navigator.of(context).pop(detailPrice.text);

    detailPrice.clear();
  }

  static void editWorkDialog(BuildContext context, Work work) {
    title.text = work.title;
    price.text = work.price.toString();
    time.text = work.time.toString();
    file = null;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Edit Work'),
              content: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EditImage(imageUrl: work.imageDownloadUrl),
                      SizedBox(height: 5),
                      TextField(
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'Work name',
                            icon: Icon(Icons.work, color: Colors.black54),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.blue))),
                        controller: title,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: TextField(
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Price',
                                icon: Icon(Icons.monetization_on,
                                    color: Colors.black54),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blue))),
                            controller: price,
                          )),
                          SizedBox(width: 15),
                          Expanded(
                              child: TextField(
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Time',
                                icon: Icon(Icons.access_time_filled,
                                    color: Colors.black54),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blue))),
                            controller: time,
                          ))
                        ],
                      )
                    ],
                  ),
                );
              }),
              actions: [
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Ok'),
                  onPressed: () => updateWork(context, work.uid, work.image),
                ),
              ],
            ));
  }

  static void updateWork(
      BuildContext context, String uid, String imagePath) async {
    if (title.text != "" && price.text != "" && time.text != "") {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Editing work...')));
      final result = await Database.updateWork(
          uid: uid,
          name: title.text,
          price: int.parse(price.text),
          time: double.parse(time.text),
          imagePath: imagePath,
          file: file);

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Success!'), duration: Duration(seconds: 2)));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error!'), duration: Duration(seconds: 2)));
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fill in all the fields!')));
    }

    Navigator.of(context).pop();
  }

  static void deleteWorkDialog(
          BuildContext context, String uid, String imagePath) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Delete work'),
                content: Text('Are you sure you want to delete this work?'),
                actions: [
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () => deleteWork(context, uid, imagePath),
                  ),
                ],
              ));

  static void deleteWork(
      BuildContext context, String uid, String imagePath) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleting work...'), duration: Duration(seconds: 1)));
    final result = await Database.deleteWork(uid: uid, imagePath: imagePath);

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Success!'), duration: Duration(seconds: 2)));
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error!'), duration: Duration(seconds: 2)));
    }

    Navigator.of(context).pop();
  }

  static void addWorkDialog(BuildContext context) {
    title.text = "";
    price.text = "";
    time.text = "";
    file = null;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add Work'),
              content: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EditImage(),
                      SizedBox(height: 5),
                      TextField(
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'Work name',
                            icon: Icon(Icons.work, color: Colors.black54),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.blue))),
                        controller: title,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: TextField(
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Price',
                                icon: Icon(Icons.monetization_on,
                                    color: Colors.black54),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blue))),
                            controller: price,
                          )),
                          SizedBox(width: 15),
                          Expanded(
                              child: TextField(
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Time',
                                icon: Icon(Icons.access_time_filled,
                                    color: Colors.black54),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blue))),
                            controller: time,
                          ))
                        ],
                      )
                    ],
                  ),
                );
              }),
              actions: [
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    addWork(context);
                  },
                ),
              ],
            ));
  }

  static void addWork(BuildContext context) async {
    if (title.text != "" && price.text != "" && time.text != "") {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Adding new work...')));
      String image;
      String imageDownloadUrl;
      if (file == null) {
        image = 'images/default_image';
        imageDownloadUrl = 'https://firebasestorage.googleapis.com/v0/b/service-station-b2847.appspot.com/o/images%2Fdefault_image.jpg?alt=media&token=aeb1f39d-4e59-4ab7-8ee5-c1f23537e180';
      }
      else {
        image = 'images/${file!.name}';
        imageDownloadUrl = await Database.uploadImage(platformFile: file!);
      }

      final result = await Database.addWork(
          name: title.text,
          price: int.parse(price.text),
          time: double.parse(time.text),
          image: image,
          imageDownloadUrl: imageDownloadUrl);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Success!'), duration: Duration(seconds: 2)));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error!'), duration: Duration(seconds: 2)));
      }

      file = null;
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fill in all the fields!'), duration: Duration(seconds: 2)));
    }

    Navigator.of(context).pop();
  }
}
