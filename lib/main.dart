import 'package:connecthub_social/controller/bottom_controller.dart';
import 'package:connecthub_social/controller/comment_controller.dart';
import 'package:connecthub_social/controller/firebase_auth_contriller.dart';
import 'package:connecthub_social/controller/follow_service_controller.dart';
import 'package:connecthub_social/controller/home_page_controller.dart';
import 'package:connecthub_social/controller/image_controller.dart';
import 'package:connecthub_social/controller/sigin_page.dart';
import 'package:connecthub_social/controller/user_controller.dart';
import 'package:connecthub_social/firebase_options.dart';
import 'package:connecthub_social/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
 // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
                ChangeNotifierProvider(
          create: (context) => FollowServiceController(),
        ),
              ChangeNotifierProvider(
          create: (context) => UserController(),
        ),
               ChangeNotifierProvider(
          create: (context) => CommentController(),
        ),
          ChangeNotifierProvider(
          create: (context) => BottomController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
