import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// This function is used to select the Multiple images from the device and 
// return a reference of such selected images file located in that device
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


// This function takes 3 arguments 
/// 1. a list of XFile [imageFiles], which is typically reference to Image file in the device, which is also a return of imagePicker.pickMuliImage() function.
/// 2. a [path] in the firebase cloud storage that is to be saved 
/// 3. a [name] for the image, which assumes to be unique
/// This function will return a list of download url for the supplied images to upload.
// We are also appending microsecondsSinceEpoch to image name, so we can assume that all the images have a totally unique path and reference in the cloud storage, and they are never overriten
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


// This function will take 2 arguments
// 1. the XFile that is to be uploaded, This will be a reference to the file in device
// 2. a firebase cloud storage reference to save that XFile
// Returns a download Url for the uploaded file
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
