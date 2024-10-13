import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:school_management/controllers/home_controller.dart';
import 'package:school_management/pages/home_page/Home_page.dart';
import 'package:school_management/pages/notce_page/notce_page.dart';
import 'package:school_management/pages/notice_page/notice_page.dart';
import 'package:school_management/pages/result_page/result_page.dart';
import 'package:school_management/pages/rutin_page/rutin_page.dart';
import 'package:school_management/pages/video_lecture_page/video_lecture.dart';

class Home extends StatefulWidget {

  const Home();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map payload ={};
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    var navbarItem = [
      BottomNavigationBarItem(icon: Icon(Icons.home, size: 15), label: "হোম"),
      BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined, size: 15), label: "ফলাফল"),
      BottomNavigationBarItem(icon: Icon(Icons.edit_notifications_outlined, size: 15), label: "নোটিশ"),
      BottomNavigationBarItem(icon: Icon(Icons.maps_home_work_outlined, size: 15), label: "রুটিন"),
      BottomNavigationBarItem(icon: Icon(Icons.note, size: 15), label: "নোটস"),
      BottomNavigationBarItem(icon: Icon(Icons.video_camera_back_outlined, size: 15), label: "ভিডিও লেকচার"),
    ];

    var navbody = [
      HomePage(),
      ResultPage(),
      NoticePage(),
      RutinPage(),
      NotcePage(),
      VideoLecture(),
    ];

    final data = ModalRoute.of(context)!.settings.arguments;

    if(data is RemoteMessage){
      payload = data.data;
    }

    if(data is NotificationResponse){
      payload = jsonDecode(data.payload!);
    }
    return WillPopScope(
      onWillPop: () async {
        // Show dialog when back button is pressed
        if (controller.currentNaIndex.value == 0) {
          bool shouldExit = await _showExitPopup(context);
          return shouldExit; // Return true if Yes is pressed, false otherwise
        } else {
          controller.currentNaIndex.value = 0; // Navigate to Home if not already there
          return false; // Prevent back navigation
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(() => Expanded(child: navbody.elementAt(controller.currentNaIndex.value))),
          ],
        ),
        bottomNavigationBar: Obx(
              () => BottomNavigationBar(
            currentIndex: controller.currentNaIndex.value,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedIconTheme: IconThemeData(color: Colors.red),
            selectedItemColor: Colors.red,
            selectedLabelStyle: TextStyle(fontFamily: 'DMSerifText-Italic'),
            onTap: (value) {
              controller.currentNaIndex.value = value;
            },
            items: navbarItem,
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitPopup(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("অ্যাপ থেকে প্রস্থান করুন"),
        content: Text("আপনি কি সত্যিই প্রস্থান করতে চান?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay in the app
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Exit the app
            child: Text("Yes"),
          ),
        ],
      ),
    ) ??
        false; // Return false if no option is selected
  }
}

