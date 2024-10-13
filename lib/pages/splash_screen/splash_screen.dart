import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:school_management/controllers/auth_service.dart';
import 'package:school_management/pages/auth_screens/login_screen.dart';
import 'package:school_management/pages/home_page/Home_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {

   SplashScreen({super.key,});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  changeScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mytoken = prefs.getString('token');
    print(mytoken); // Check if token is null

    Future.delayed(Duration(seconds: 2), () {
      if (mytoken != null && !JwtDecoder.isExpired(mytoken)) {
        Get.to(() => Home());
      } else {
        Get.to(() => LoginPage());
      }
    });
  }




  @override
  void initState() {
    // TODO: implement initState

    changeScreen();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor:Colors.white ,
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/schoolnewlogo.jpg'),
          ],
        ) ,
      ),
    );

  }
}