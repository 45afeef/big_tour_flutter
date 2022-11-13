import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<List<XFile>> selectImages() async {
  final imagePicker = ImagePicker();

  //Check Permissions
  await Permission.storage.request();

  var permissionStatus = await Permission.storage.status;

  if (permissionStatus.isGranted) {
    final List<XFile> images = await imagePicker.pickMultiImage();
    return images;
  }
  return [];
}

Future<List<String>> uploadImages(
  List<XFile> imageFiles,
  String path,
  String name,
) async {
  final storageRef = FirebaseStorage.instance.ref().child(path).child(name);
  final List<String> imageUrls = [];
  for (var xFile in imageFiles) {
    // Upload each image file
    String? imageUrl = await uploadFile(
      xFile,
      storageRef.child(DateTime.now().microsecondsSinceEpoch.toString()),
    );
    imageUrls.add(imageUrl);
  }
  return imageUrls;
}

Future<String> uploadFile(XFile file, Reference ref) async {

  TaskSnapshot uploadTask;

  final metadata = SettableMetadata(
    contentType: 'image/jpeg',
    customMetadata: {'picked-file-path': file.path},
  );

  if (kIsWeb) {
    uploadTask = await ref.putData(await file.readAsBytes(), metadata);
  } else {
    uploadTask = await ref.putFile(File(file.path), metadata);
  }
  String downlaodUrl = await uploadTask.ref.getDownloadURL();
  return downlaodUrl;
}
