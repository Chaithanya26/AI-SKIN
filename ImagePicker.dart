import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
 
class ImageHelper {
  static final ImagePicker _picker = ImagePicker();
 
  // Pick image from gallery
  static Future<Uint8List?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;
 
      if (kIsWeb) {
        return await image.readAsBytes();
      } else {
        return await image.readAsBytes(); // works for mobile too
      }
    } catch (e) {
      print("Gallery pick error: $e");
      return null;
    }
  }
 
  // Take photo using camera
  static Future<Uint8List?> takePhotoWithCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return null;
 
      return await image.readAsBytes();
    } catch (e) {
      print("Camera capture error: $e");
      return null;
    }
  }
}
 