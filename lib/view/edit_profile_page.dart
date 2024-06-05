import 'dart:io';

import 'package:connecthub_social/controller/firebase_auth_contriller.dart';
import 'package:connecthub_social/controller/image_controller.dart';
import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/service/firebase_auth_implimentetion.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  UserModel userModel;
  final String id;
  EditProfilePage({super.key, required this.userModel, required this.id});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController usernameCtrl = TextEditingController();
  bool isNewImagePicked = false;
  @override
  void initState() {
    usernameCtrl = TextEditingController(text: widget.userModel.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ImagesProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(221, 47, 46, 46),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<ImagesProvider>(builder: (context, pro, _) {
                  return CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 211, 210, 206),
                    radius: 40,
                    backgroundImage: isNewImagePicked
                        ? FileImage(pro.editPickedImage!)
                        : widget.userModel?.image != null
                            ? NetworkImage(
                                    widget.userModel?.image.toString() ?? "no")
                                as ImageProvider
                            : null,
                  );
                }),
                TextButton(
                  onPressed: () async {
                    await provider.editPickImg();
                    setState(() {
                      isNewImagePicked = true;
                    });
                  },
                  child: const Text("Pick Image"),
                ),
                Gap(20),
                TextFormField(
                  controller: usernameCtrl,
                  decoration: InputDecoration(
                      label: Text(
                        "UserName",
                        style: TextStyle(color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  style: TextStyle(color: Colors.white),
                ),
                Gap(14),
                ElevatedButton(
                    onPressed: () {
                      edituserPage(context);
                    },
                    child: Text("submit"))
              ],
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
    String imageUrl = widget.userModel.image.toString();
    if (isNewImagePicked) {
      imageUrl = await service.updateImage(
          imageUrl, File(imageProvider.editPickedImage!.path), context);
    }
    final newData = usernameCtrl.text;
    await pro.EditUserProfile(context, newData, widget.id);
    Navigator.pop(context);
  }
}
