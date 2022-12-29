import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

final CollectionReference _collection = FirebaseFirestore.instance.collection('Works');

class Database {

  static Stream<QuerySnapshot> readWorks() {
    CollectionReference collection = _collection;
    return collection.snapshots();
  }

  static Future<bool> updateWork({ required String uid, required String name, required int price, required double time, String? imagePath, PlatformFile? file }) async {
    DocumentReference documentReference = _collection.doc(uid);
    Map<String, dynamic> data;
    if (file == null) {
      data = <String, dynamic>{
        'name': name,
        'price': price,
        'time': time,
      };
    }
    else {
      String imageDownloadUrl = await uploadImage(platformFile: file);
      data = <String, dynamic>{
        'name': name,
        'price': price,
        'time': time,
        'image': 'images/${file.name}',
        'imageDownloadUrl': imageDownloadUrl
      };
      await deleteImage(filePath: imagePath!);
    }
    return await documentReference.update(data).then((value) => true).catchError((error) => false);
  }

  static Future<bool> deleteWork({ required String uid, required String imagePath }) async {
    await deleteImage(filePath: imagePath);

    DocumentReference documentReference = _collection.doc(uid);
    return await documentReference.delete().then((value) => true).catchError((error) => false);
  }

  static Future<bool> addWork({ required String name, required int price, required double time, required String image, required String imageDownloadUrl }) async {
    DocumentReference documentReference = _collection.doc();
    Map<String, dynamic> data = <String, dynamic>{
      'name': name,
      'price': price,
      'time': time,
      'image': image,
      'imageDownloadUrl': imageDownloadUrl
    };

    return await documentReference.set(data).then((value) => true).catchError((error) => false);
  }

  static Future<String> uploadImage({ required PlatformFile platformFile }) async {
    final path = 'images/${platformFile.name}';
    final file = File(platformFile.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);

    return await getImageDownloadUrl(filePath: path);
  }

  static Future<String> getImageDownloadUrl({ required String filePath }) async {
    String url = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    return url;
  }

  static Future deleteImage({ required String filePath }) async {
    if (filePath == 'images/default_image') return;
    await FirebaseStorage.instance.ref(filePath).delete();
  }
}
