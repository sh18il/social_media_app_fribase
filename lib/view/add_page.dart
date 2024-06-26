import 'dart:developer';
import 'dart:io';
import 'package:connecthub_social/controller/image_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddPage extends StatelessWidget {
  String? username;
  AddPage({super.key, this.username});
  @override
  Widget build(BuildContext context) {
    log("addScreen");
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<ImagesProvider>(context, listen: false);
    return SafeArea(
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          provider.clearPickedImage();
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(221, 47, 46, 46),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(221, 47, 46, 46),
            title: const Text(
              " New Post Create",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Container(
            height: height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image:
                        AssetImage("assets/images/red-black-papercut-.jpg"))),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Consumer<ImagesProvider>(builder: (context, pro, _) {
                      return FutureBuilder<File?>(
                        future: Future.value(pro.pickedImage),
                        builder: (context, snapshot) {
                          return Container(
                            height: height * 0.4,
                            width: width,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 42, 40, 40),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color.fromARGB(255, 62, 60, 60),
                                width: 1,
                              ),
                              image: snapshot.data != null
                                  ? DecorationImage(
                                      image: FileImage(snapshot.data!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: snapshot.data == null
                                ? Center(
                                    child: Text(
                                      "No image selected",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                : null,
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 20),
                    Text(
                      "pick image",
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            provider.pickImg();
                          },
                          icon: const Icon(
                            Icons.photo,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            provider.pickImgCam();
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: provider.descriptionCtrl,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        provider.add(context, false);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 19, 30, 55),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: provider.isLoading
                          ? CircularProgressIndicator()
                          : Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
