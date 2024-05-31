import 'package:connecthub_social/service/firebase_auth_implimentetion.dart';
import 'package:connecthub_social/view/home_page.dart';
import 'package:connecthub_social/widgets/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SingupPage extends StatefulWidget {
  const SingupPage({super.key});

  @override
  State<SingupPage> createState() => _SingupPageState();
}

class _SingupPageState extends State<SingupPage> {
  FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(
            children: [
              Gap(20),
              Container(
                height: 100,
                child: Center(child: Text("Sing_Up")),
              ),
              TextFormField(
                controller: userNameCtrl,
                decoration: InputDecoration(
                    label: Text("user name"),
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
                    label: Text("password"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              Gap(30),
              SizedBox(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 114, 152, 218)),
                    onPressed: () {
                      _sigUp();
                    },
                    child: Text(
                      "Sing Up",
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

  void _sigUp() async {
    String username = userNameCtrl.text;
    String email = emailCtrl.text;
    String password = passwordCtrl.text;

    User? user = await _auth.singupWithEmailAndPassword(
        context, username, email, password);

    if (user != null) {
      print("user is succes");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BottomNav(),
      ));
    }
  }
}
