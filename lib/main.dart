import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:school_management/models/notice_model.dart';
import 'package:school_management/pages/auth_screens/login_screen.dart';
import 'package:school_management/pages/auth_screens/signup_screen.dart';
import 'package:school_management/pages/home_page/Home_dart.dart';
import 'package:school_management/pages/notce_page/notce_page.dart';
import 'package:school_management/pages/notice_page/notice_page.dart';
import 'package:school_management/pages/result_page/result_page.dart';
import 'package:school_management/pages/splash_screen/splash_screen.dart';
import 'package:school_management/pages/video_lecture_page/video_lecture.dart';

import 'package:school_management/servises/notification/notification_service.dart';


import 'package:timezone/data/latest.dart' as tz;

final navigatorKey = GlobalKey<NavigatorState>();
// function  to lisen to bckground changes
Future _firebaseBackgroundMessage(RemoteMessage message)async{
  if(message.notification != null){
    print("some notification recieved in background");

  }

}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCZRTUxnfZVPc5J78SCowpUEhw6Sao9EcA",
        appId:"1:788385214840:android:5c7bdbbdbce18864e4588d",
        messagingSenderId: "788385214840",
        projectId: "somikorn",
        storageBucket: "somikorn.appspot.com",

      ));


  // inialize firebase messaging
  await PushNotifications.init();


  //initialize local notification

  await PushNotifications.localNotiInit();

  // Listen to background notifications

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // on Baground Notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Background Notification tapped");
      navigatorKey.currentState!.pushNamed("/home", arguments: message.data);
    }
  });

  // to handle foreground notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message){
    String payloadData = jsonEncode(message.data);
    if(message.notification !=null){
      PushNotifications.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData,
      );
    }
  });

  // for handling in terminated state
  final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    print("Launched from terminated state");
    Future.delayed(Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed("/home", arguments: message.data);
    });
  }

  tz.initializeTimeZones(); // Initialize timezone for notifications

  runApp(const MyApp());
}

// You can use this function wherever appropriate in your app to manually check for notice updates


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
     navigatorKey: navigatorKey,
     routes: {
        "/": (context) => SplashScreen(),
       "/home":(context) => Home(),
       "/login":(context) => LoginPage(),
       "/signUp":(context) => SignUpScreen(),
       "/result":(context) => ResultPage(),
       "/notice": (context) => NoticePage(),
       "/notce" :(context) => NotcePage(),
       "/videoLecture": (context) => VideoLecture(),
     },
    );
  }
}


