import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> uploadImageToCloudStorageFromGallery(
    {required String path, required String name}) async {
      // This function will save the image to cloud storage and return a download url
  final _firebaseStorage = FirebaseStorage.instance
      .ref()
      .child(path)
      .child(name + DateTime.now().microsecondsSinceEpoch.toString());
  final _imagePicker = ImagePicker();

  PickedFile? image;

  //Check Permissions
  await Permission.storage.request();

  var permissionStatus = await Permission.storage.status;

  if (permissionStatus.isGranted) {
    //Select Image
    image = await _imagePicker.getImage(source: ImageSource.gallery);
    var file = File(image?.path ?? "");

    if (image != null) {
      String imageUrl;

      //Upload to Firebase
      var snapshot = await _firebaseStorage.putFile(file);
      imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } else {
      return 'No Image Path Received';
    }
  } else {
    return 'Permission not granted. Try Again with permission access';
  }
}
