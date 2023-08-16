import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splitwise_app/screens/split_expense_screen.dart';

Future<String> addAvatar(XFile imagePicked) async {
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceDirImage = referenceRoot.child('avatars');
  String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
  // if (path != null && path != uniqueFileName) {
  //   await delete("avatars/images/$path.jpeg");
  // }
  path = uniqueFileName;
  Reference referenceImageToUpload = referenceDirImage.child(uniqueFileName);

  try {
    await referenceImageToUpload.putFile(File(imagePicked.path));
    String imageUrl = await referenceImageToUpload.getDownloadURL();
    return imageUrl;
  } catch (e) {
    return "";
  }
}

Future<void> delete(String ref) async {
  // print(object)
 try {
    await FirebaseStorage.instance.refFromURL(ref).delete();
 // ignore: unused_catch_clause, empty_catches
 }on FirebaseException catch (e) {
   
 }
}
