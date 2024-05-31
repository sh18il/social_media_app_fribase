import 'dart:io';

import 'package:connecthub_social/controller/image_controller.dart';
import 'package:connecthub_social/model/image_post_model.dart';
import 'package:connecthub_social/service/image_post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPage extends StatelessWidget {
  String? email;
  AddPage({super.key, this.email});

  TextEditingController descriptionCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Consumer<ImagesProvider>(builder: (context, pro, _) {
                  return FutureBuilder(
                    future: Future.value(pro.pickedImage),
                    builder: (context, snapshot) {
                      return CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(255, 125, 124, 122),
                        radius: 40,
                        backgroundImage: snapshot.data != null
                            ? FileImage(snapshot.data!)
                            : null,
                      );
                    },
                  );
                }),
              ),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<ImagesProvider>(context, listen: false)
                        .pickImg();
                  },
                  child: Text("add pic")),
              TextFormField(
                controller: descriptionCtrl,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              ElevatedButton(
                  onPressed: () {
                    add(context);
                  },
                  child: Text("submit")),
            ],
          ),
        ),
      ),
    );
  }

  add(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    ImagePostService services = ImagePostService();
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
    await services.addImage(File(imageProvider.pickedImage!.path), context);

    ImagePostModel imModel = ImagePostModel(
        image: services.url, description: descriptionCtrl.text, uid: user);

    await services.addPost(imModel);
  
  }
}
