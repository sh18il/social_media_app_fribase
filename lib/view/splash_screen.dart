import 'package:connecthub_social/view/auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 47, 46, 46),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/splash.jpg"))),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                  image: AssetImage(
                      "assets/images/a-sleek-and-modern-3d-render-of-the-connect-hub-lo-aDv3q1bOTGO9qCZ23zbUWg-EVwOSYhYQiOQxM4Ubzil_A-removebg-preview.png")),
              const Text(
                "WELCOME",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Gap(20),
              LoadingAnimationWidget.newtonCradle(
                color: const Color.fromARGB(255, 255, 255, 255),
                size: 130,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
