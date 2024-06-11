import 'package:connecthub_social/view/auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const AuthPage(),
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(221, 47, 46, 46),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                image: AssetImage(
                    "assets/images/a-sleek-and-modern-3d-render-of-the-connect-hub-lo-aDv3q1bOTGO9qCZ23zbUWg-EVwOSYhYQiOQxM4Ubzil_A-removebg-preview.png")),
            Text(
              "CONNECT_HUB",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Gap(20),
            Text("WELCOME..")
          ],
        ),
      ),
    );
  }
}
