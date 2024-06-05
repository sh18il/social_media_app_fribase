import 'dart:io';
import 'package:connecthub_social/controller/sigin_page.dart';
import 'package:connecthub_social/service/firebase_auth_implimentetion.dart';

import 'package:connecthub_social/view/home_page.dart';
import 'package:connecthub_social/widgets/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
                    _selectedImage = snapshot.data;
                    return Container(
                      height: height * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(70),
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
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : null,
                    );
                  },
                );
              }),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Provider.of<SginPageController>(context, listen: false)
                      .pickImg();
                },
                icon: Icon(Icons.add_a_photo),
                label: Text("Add Picture"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Gap(20),
              Container(
                height: 20,
                child: Center(child: Text("Sign Up")),
              ),
              TextFormField(
                controller: userNameCtrl,
                decoration: InputDecoration(
                    label: Text("User Name"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              Gap(30),
              TextFormField(
                controller: emailCtrl,
                decoration: InputDecoration(
                    label: Text("Email or Phone"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              Gap(30),
              TextFormField(
                controller: passwordCtrl,
                decoration: InputDecoration(
                    label: Text("Password"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              Gap(30),
              SizedBox(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 114, 152, 218)),
                    onPressed: () {
                      _signUp();
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )),
              ),
              Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: ClipRRect(
                            child: Image(
                                width: width * 0.08,
                                image: NetworkImage(
                                    "https://static.vecteezy.com/system/resources/previews/022/484/503/non_2x/google-lens-icon-logo-symbol-free-png.png")),
                          ),
                        ),
                        Gap(30),
                        InkWell(
                          onTap: () {},
                          child: ClipRRect(
                            child: Image(
                                width: width * 0.08,
                                image: NetworkImage(
                                    "https://seeklogo.com/images/G/github-logo-5F384D0265-seeklogo.com.png")),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Gap(50),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String username = userNameCtrl.text;
    String email = emailCtrl.text;
    String password = passwordCtrl.text;

    if (_selectedImage != null) {
      await _auth.addImage(_selectedImage!, context);
      String imageUrl = _auth.url;

      User? user = await _auth.signupWithEmailAndPassword(
          context, username, email, password, imageUrl);

      if (user != null) {
        print("User is successful");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BottomNav(),
        ));
      }
    } else {
      ShowSnackBar(context, "Please select an image");
    }
  }
}
