import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:service_station/other/dialogues.dart';

class EditImage extends StatefulWidget {
  const EditImage({Key? key, this.imageUrl}) : super(key: key);

  final String? imageUrl;

  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextButton(
          onPressed: () async {
            await selectFile();
          },
          child: imageWidget(),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Icon(Icons.edit,
                  color: Colors.black, size: 10),
            ),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    50,
                  ),
                ),
                color: Colors.grey,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2, 4),
                    color: Colors.black.withOpacity(
                      0.3,
                    ),
                    blurRadius: 3,
                  ),
                ]),
          ),
        ),
      ],
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() => Dialogues.file = result.files.first);
  }

  Widget imageWidget() {
    if (Dialogues.file != null) {
      return Image.file(File(Dialogues.file!.path!), width: 55, height: 55);
    }
    else if (widget.imageUrl != null) {
      return Image.network(widget.imageUrl!, width: 55, height: 55);
    }
    else {
      return Image.network('https://firebasestorage.googleapis.com/v0/b/service-station-b2847.appspot.com/o/images%2Fdefault_image.jpg?alt=media&token=aeb1f39d-4e59-4ab7-8ee5-c1f23537e180', width: 55, height: 55);
    }
  }

}
