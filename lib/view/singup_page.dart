import 'dart:io';

import 'package:connecthub_social/controller/sigin_page.dart';
import 'package:connecthub_social/service/firebase_auth_implimentetion.dart';
import 'package:connecthub_social/widgets/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                opacity: 0.8,
                fit: BoxFit.fill,
                image: AssetImage("assets/images/asbtract-gradient-r.avif"))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                          border: Border.all(
                            color: Colors.black,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
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
              Center(
                child: InkWell(
                  onTap: () {
                    Provider.of<SginPageController>(context, listen: false)
                        .pickImg();
                  },
                  child: Container(
                    width: width * 0.4,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                        child: Text(
                      "Add Picture",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ),
              const Gap(20),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: userNameCtrl,
                decoration: InputDecoration(
                    label: const Text(
                      "User Name",
                      style: TextStyle(color: Colors.white),
                    ),
                    border: UnderlineInputBorder()),
                style: TextStyle(color: Colors.white),
              ),
              const Gap(30),
              TextFormField(
                controller: emailCtrl,
                decoration: InputDecoration(
                    label: const Text(
                      "Email",
                      style: TextStyle(color: Colors.white),
                    ),
                    border: UnderlineInputBorder()),
                style: TextStyle(color: Colors.white),
              ),
              const Gap(30),
              TextFormField(
                controller: passwordCtrl,
                decoration: InputDecoration(
                    label: const Text(
                      "Password",
                      style: TextStyle(color: Colors.white),
                    ),
                    border: UnderlineInputBorder()),
                style: TextStyle(color: Colors.white),
              ),
              const Gap(30),
              SizedBox(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 144, 221, 105)),
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
      imageUrl = service.url ?? '';
    } else {
      File defaultImage =
          await getImageFileFromAssets('assets/images/1077114.png');
      await service.addImage(defaultImage, context);
      imageUrl = service.url ?? '';
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

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);

    final file =
        File('${(await getTemporaryDirectory()).path}/default_image.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file;
  }
}
