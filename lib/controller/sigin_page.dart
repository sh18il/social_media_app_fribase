import 'dart:io';
import 'package:connecthub_social/service/firebase_auth_implimentetion.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SginPageController extends ChangeNotifier {
  FirebaseAuthService service = FirebaseAuthService();
  File? pickedImage;
  File? editPickedImage;
  ImagePicker image = ImagePicker();

  Future<void> pickImg() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    pickedImage = File(img!.path);
    notifyListeners();
  }

  Future<void> editPickImg() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    editPickedImage = File(img!.path);
    notifyListeners();
  }

  void clearPickedImage() {
    pickedImage = null;
    notifyListeners();
  }

  void clearEditImage() {
    editPickedImage = null;
    notifyListeners();
  }
  
}
