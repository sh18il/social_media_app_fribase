import 'package:connecthub_social/controller/firebase_auth_contriller.dart';
import 'package:connecthub_social/controller/home_page_controller.dart';
import 'package:connecthub_social/controller/image_controller.dart';
import 'package:connecthub_social/controller/sigin_page.dart';
import 'package:connecthub_social/firebase_options.dart';
import 'package:connecthub_social/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ImagesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeController(),
        ),
        ChangeNotifierProvider(
          create: (context) => SginPageController(),
        ),
          ChangeNotifierProvider(
          create: (context) => FirebaseAuthContriller(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
