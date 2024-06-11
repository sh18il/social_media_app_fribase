import 'dart:io';

import 'package:connecthub_social/controller/sigin_page.dart';
import 'package:connecthub_social/service/firebase_auth_implimentetion.dart';
import 'package:connecthub_social/widgets/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    // final provider =
    //     Provider.of<FirebaseAuthContriller>(context, listen: false);
    // final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(
            children: [
              Consumer<SginPageController>(builder: (context, pro, _) {
                return FutureBuilder<File?>(
                  future: Future.value(pro.pickedImage),
                  builder: (context, snapshot) {
                    selectedImage = snapshot.data;
                    return CircleAvatar(
                      maxRadius: 60,
                      child: Container(
                        width: width * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(70),
                          image: selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(snapshot.data!),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image:
                                      AssetImage("assets/images/1077114.png")),
                        ),
                       
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Provider.of<SginPageController>(context, listen: false)
                      .pickImg();
                },
                icon: const Icon(Icons.add_a_photo),
                label: const Text("Add Picture"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const Gap(20),
              const SizedBox(
                height: 20,
                child: Center(child: Text("Sign Up")),
              ),
              TextFormField(
                controller: userNameCtrl,
                decoration: InputDecoration(
                    label: const Text("User Name"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const Gap(30),
              TextFormField(
                controller: emailCtrl,
                decoration: InputDecoration(
                    label: const Text("Email or Phone"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const Gap(30),
              TextFormField(
                controller: passwordCtrl,
                decoration: InputDecoration(
                    label: const Text("Password"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const Gap(30),
              SizedBox(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 114, 152, 218)),
                    onPressed: () {
                      signUp(context);
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )),
              ),
              const Gap(20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                ],
              ),
              const Gap(50),
            ],
          ),
        ),
      ),
    );
  }

  void signUp(BuildContext context) async {
    FirebaseAuthService service = FirebaseAuthService();
    String username = userNameCtrl.text;
    String email = emailCtrl.text;
    String password = passwordCtrl.text;

    String imageUrl = '';
    if (selectedImage != null) {
      await service.addImage(selectedImage!, context);
      imageUrl = service.url;
    }

    User? user =
        await service.signup(context, username, email, password, imageUrl);

    if (user != null) {
      print("User is successful");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const BottomNav(),
      ));
    }
  }
}
