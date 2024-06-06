import 'package:connecthub_social/controller/firebase_auth_contriller.dart';
import 'package:connecthub_social/service/firebase_auth_implimentetion.dart';
import 'package:connecthub_social/view/home_page.dart';
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
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Gap(20),
                Container(
                  height: 180,
                  child: Image(
                      image: AssetImage(
                          "assets/images/hub-logo-design-template-free-vector-removebg-preview.png")),
                ),
                TextFormField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                      label: Text("Email"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                Gap(30),
                TextFormField(
                  obscureText: true,
                  controller: passwordCtrl,
                  decoration: InputDecoration(
                      label: Text("password"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                Gap(30),
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
                      child: Center(child: Text('Login')),
                    ),
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignupPage(),
                          ));
                        },
                        child: Text("Sing-Up")),
                  ],
                ),
                Gap(20),
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
                              FirebaseAuthService().signInWithGoogle();
                            },
                            child: ClipRRect(
                              child: Image(
                                  width: width * 0.08,
                                  image: NetworkImage(
                                      "https://static.vecteezy.com/system/resources/previews/022/484/503/non_2x/google-lens-icon-logo-symbol-free-png.png")),
                            ),
                          ),
                          Gap(30),
                          // InkWell(
                          //   onTap: () {},
                          //   child: ClipRRect(
                          //     child: Image(
                          //         width: width * 0.08,
                          //         image: NetworkImage(
                          //             "https://seeklogo.com/images/G/github-logo-5F384D0265-seeklogo.com.png")),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {}, child: Text("Forget password"))
                      ],
                    ),
                  ],
                ),
                Gap(50),
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
          builder: (context) => BottomNav(),
        ),
        (route) => false,
      );
    } else {
      print("some error happend");
    }
  }
}
