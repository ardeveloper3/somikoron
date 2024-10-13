
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:school_management/controllers/auth_service.dart';
import 'package:school_management/controllers/crude_service.dart';
import 'package:school_management/main.dart';
import 'package:school_management/servises/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotifications {
  static  final  _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // request Notification permisstion
  static Future init()async{
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: false,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
  }
  //this is pushNotification class

  static Future<void> setDivicetken() async {
  try {
  // Get the device FCM token
  final token = await _firebaseMessaging.getToken();
  print("Device token: $token");

  if (token != null) {
  // Save the device token in SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('deviceToken', token);
  print("Device token saved in SharedPreferences");

  // Check if the user is logged in

  }

  // Listen for token refresh events and save the new token
  _firebaseMessaging.onTokenRefresh.listen((newToken) async {
  print("New device token: $newToken");

  // Save the refreshed token in SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('deviceToken', newToken);
  print("New device token saved in SharedPreferences ");

  // Update FCM token on the server

  });
  } catch (e) {
  print("Error in getting device token: $e");
  }
  }



  static Future getDeviceToken()async{
    // get the device fcm token
    final token =  await _firebaseMessaging.getToken();
    print("device token:$token");

    bool isUserLoggedin = await AuthService.isLoggedIn();
    if(isUserLoggedin){
      await CRUDService.saveUserToken(token!);
      print("save to firestore");
    }
    //also save if token change

    _firebaseMessaging.onTokenRefresh.listen((event)async{
      await CRUDService.saveUserToken(event); // Save the new device token
      print("Device token saved: $event");
    });
  }
  // initialize local notifications
  static Future localNotiInit()async{
    const AndroidInitializationSettings initializationSettingAndroid =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',

    );
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title , body , payload) => null,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingAndroid,
        iOS: initializationSettingsDarwin
    );

    //request notification permission for android 13 or above

    _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation
    <AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();


    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:onNotificationTap ,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,);
  }
//on tap local Notification in foreground

  static void onNotificationTap(NotificationResponse notificationResponse){

    navigatorKey.currentState!.pushNamed("/home",arguments: notificationResponse);

  }
//show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  })async{
    const AndroidNotificationDetails androidNotificationDetails =  AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker'
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(
      android: androidNotificationDetails,
    );
    await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails,payload: payload);
  }

}
