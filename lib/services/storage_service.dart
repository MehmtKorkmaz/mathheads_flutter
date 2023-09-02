import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class StorageService extends GetxController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();

  Future imageFromGallery() async {
    //  take a photo from gallery

    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      File _image = File(image.path);

      return _image;
    }
  }

// it sends photo to storage and returns photo url
  Future<String> uploadImage(File imageFile) async {
    String path = '${DateTime.now().millisecondsSinceEpoch}';

    TaskSnapshot uploadTask =
        await _storage.ref().child('photos').child(path).putFile(imageFile);
    String uploadedImageUrl = await uploadTask.ref.getDownloadURL();
    return uploadedImageUrl;
  }
}
