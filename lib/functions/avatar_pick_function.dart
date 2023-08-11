

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

Future<String> addAvatar(XFile imagePicked)async{
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceDirImage = referenceRoot.child('avatars');
  String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
  Reference referenceImageToUpload = referenceDirImage.child(uniqueFileName);

  try {
    print('keriiii');
    await referenceImageToUpload.putFile(File(imagePicked.path));
    String imageUrl = await referenceImageToUpload.getDownloadURL();
    print(imageUrl);
    return imageUrl;
  } catch (e) {
    return "";
    
  }
}
