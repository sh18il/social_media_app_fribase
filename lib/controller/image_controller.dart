import 'dart:io';

import 'package:connecthub_social/model/image_post_model.dart';
import 'package:connecthub_social/service/follow_service.dart';
import 'package:connecthub_social/service/image_post_service.dart';
import 'package:connecthub_social/widgets/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagesProvider extends ChangeNotifier {
  TextEditingController descriptionCtrl = TextEditingController();
  ImagePostService service = ImagePostService();
  File? pickedImage;
  File? editPickedImage;
  bool isNewImagePicked = false;
  bool isLoading = false;
  ImagePicker image = ImagePicker();
  isnewImgPicked() {
    isNewImagePicked = !isNewImagePicked;
    notifyListeners();
  }

  Future<void> pickImg() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    pickedImage = File(img!.path);
    notifyListeners();
  }

  Future<void> pickImgCam() async {
    var img = await image.pickImage(source: ImageSource.camera);
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
    descriptionCtrl.clear();
    notifyListeners();
  }

  void clearEditImage() {
    editPickedImage = null;

    notifyListeners();
  }

  deletePostImage(String imageurl, BuildContext context) async {
    await service.deleteImage(imageurl, context);

    notifyListeners();
  }

  deletePostDesCription(String id) async {
    await service.deletePost(id);
    notifyListeners();
  }

  add(BuildContext context, isLiked) async {
    isLoading = true;
    final user = FirebaseAuth.instance.currentUser!.uid;
    ImagePostService services = ImagePostService();
    // final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
    final username = await FollowService().getUserData(context, user);

    if (pickedImage != null) {
      await services.addImage(File(pickedImage!.path), context);

      ImagePostModel imModel = ImagePostModel(
        username: username!.username.toString(),
        userImage: username.image,
        image: services.url,
        description: descriptionCtrl.text,
        uid: user,
        isLiked: isLiked,
      );
      clearPickedImage();

      await services.addPost(imModel);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNav(),
        ),
        (route) => false,
      );
      isLoading = false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image.")),
      );
    }
  }
}
