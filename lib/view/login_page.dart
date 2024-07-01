import 'package:connecthub_social/controller/firebase_auth_contriller.dart';
import 'package:connecthub_social/service/firebase_auth_implimentetion.dart';
import 'package:connecthub_social/view/forgot_password_page.dart';
import 'package:connecthub_social/view/phone_page.dart';

import 'package:connecthub_social/view/singup_page.dart';
import 'package:connecthub_social/widgets/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  TextEditingController emailCtrl = TextEditingController();

  TextEditingController passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      body: Container(
        height: height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: 0.9,
                fit: BoxFit.fill,
                image: AssetImage("assets/images/torn-paper-black.jpg"))),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const Gap(20),
                const SizedBox(
                  height: 180,
                  child: Image(
                      image: AssetImage(
                          "assets/images/it-s-social-media-app-name-is-connect-hub-logo-3d--JM0aIQQSSvWkgMvE_dmyWw-EVwOSYhYQiOQxM4Ubzil_A-removebg-preview.png")),
                ),
                TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                      label: Text(
                        "Email",
                        style: TextStyle(color: Colors.white),
                      ),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              strokeAlign: BorderSide.strokeAlignOutside))),
                  style: const TextStyle(color: Colors.white),
                ),
                const Gap(30),
                TextFormField(
                  obscureText: true,
                  controller: passwordCtrl,
                  decoration: const InputDecoration(
                      label: Text(
                        "password",
                        style: TextStyle(color: Colors.white),
                      ),
                      border: UnderlineInputBorder()),
                  style: const TextStyle(color: Colors.white),
                ),
                const Gap(30),
                Consumer<FirebaseAuthContriller>(builder: (context, pro, _) {
                  return InkWell(
                    onTap: () async {
                      login(context);

                      print('Loged in');
                    },
                    child: Container(
                      height: 30,
                      width: 100,
                      color: Colors.amber,
                      child: const Center(child: Text('Login')),
                    ),
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignupPage(),
                          ));
                        },
                        child: const Text("Sing-Up")),
                  ],
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              FirebaseAuthService().signInWithGoogle(context);
                            },
                            child: ClipRRect(
                              child: Image(
                                  width: width * 0.08,
                                  image: const NetworkImage(
                                      "https://static.vecteezy.com/system/resources/previews/022/484/503/non_2x/google-lens-icon-logo-symbol-free-png.png")),
                            ),
                          ),
                          const Gap(30),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PhoneOtpPage(),
                              ));
                            },
                            child: ClipRRect(
                              child: Image(
                                  width: width * 0.08,
                                  image: const NetworkImage(
                                      "https://www.clipartmax.com/png/middle/207-2074506_sms-verification-comments-sms-black-icon-png.png")),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ));
                            },
                            child: const Text("Forget password"))
                      ],
                    ),
                  ],
                ),
                const Gap(50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    // final provider =
    //     Provider.of<FirebaseAuthContriller>(context, listen: false);
    FirebaseAuthService auth = FirebaseAuthService();
    String email = emailCtrl.text;
    String password = passwordCtrl.text;

    User? user = await auth.signin(
      context,
      email,
      password,
    );

    if (user != null) {
      print("user secssus full login");
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const BottomNav(),
        ),
        (route) => false,
      );
    } else {
      print("some error happend");
    }
  }
}
