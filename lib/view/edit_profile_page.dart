import 'dart:io';
import 'package:connecthub_social/controller/firebase_auth_contriller.dart';
import 'package:connecthub_social/controller/image_controller.dart';
import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/service/firebase_auth_implimentetion.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatelessWidget {
  UserModel userModel;
  final String id;
  EditProfilePage({super.key, required this.userModel, required this.id});

  TextEditingController usernameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    usernameCtrl = TextEditingController(text: userModel.username);
    final provider = Provider.of<ImagesProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(221, 47, 46, 46),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/red-black-papercut-.jpg"))),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Consumer<ImagesProvider>(builder: (context, pro, _) {
                    return CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(255, 211, 210, 206),
                        radius: 40,
                        backgroundImage: provider.isNewImagePicked
                            ? FileImage(pro.editPickedImage!)
                            : userModel.image != null
                                ? getImageProvider(
                                    userModel.image.toString() ?? "no")
                                : null);
                  }),
                  TextButton(
                    onPressed: () async {
                      await provider.editPickImg();
                      provider.isnewImgPicked();
                    },
                    child: const Text("Pick Image"),
                  ),
                  const Gap(20),
                  TextFormField(
                    controller: usernameCtrl,
                    decoration: InputDecoration(
                        label: const Text(
                          "UserName",
                          style: TextStyle(color: Colors.white),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Gap(14),
                  ElevatedButton(
                      onPressed: () {
                        edituserPage(context);
                      },
                      child: const Text("submit"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> edituserPage(BuildContext context) async {
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
    final pro = Provider.of<FirebaseAuthContriller>(context, listen: false);
    FirebaseAuthService service = FirebaseAuthService();
    String imageUrl = userModel.image.toString();
    if (imageProvider.isNewImagePicked) {
      imageUrl = (await service.updateImage(
          imageUrl, File(imageProvider.editPickedImage!.path), context))!;
      //  imageUrl, File(imageProvider.editPickedImage!.path), context);
    }
    final newData = usernameCtrl.text;
    await pro.EditUserProfile(context, newData, id, imageUrl);
    Navigator.pop(context);
  }

  ImageProvider getImageProvider(String? imageUrl) {
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage('assets/images/1077114.png');
    }
  }
}
