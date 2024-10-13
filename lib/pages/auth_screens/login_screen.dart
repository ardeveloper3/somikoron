import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/common_widgets/common_widget.dart';
import 'package:school_management/common_widgets/text_field.dart';
import 'package:school_management/controllers/auth_service.dart';
import 'package:school_management/models/salary.dart';
import 'package:school_management/pages/auth_screens/check.dart';
import 'package:school_management/pages/auth_screens/signup_screen.dart';
import 'package:school_management/pages/home_page/Home_dart.dart';
import 'package:school_management/servises/api_services.dart';
import 'package:school_management/servises/notification/notification_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false; // For loading animation
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
    checkAuthentication(); // Check authentication on initialization
  }


  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      print("SharedPreferences initialized successfully.");
    } else {
      print("Failed to initialize SharedPreferences.");
    }
  }

  Future<void> checkAuthentication() async {
    final token = prefs?.getString('token');
    if (token != null) {
      // If token exists, navigate to home page
      Get.offAll(() => Home());
    }
  }
  final ApiServices apiService = ApiServices(); // Create an instance of ApiService

  Future<String> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return 'Please fill out all fields.'; // Return error message
    }

    // Show loading animation
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final url = Uri.parse('https://nextjs.softravine.com/api/token/');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': emailController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var myToken = data['access'];

        // Save the token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', myToken);

        // Perform payment inquiry
        await paymentInquiry(myToken);

        await PushNotifications.setDivicetken();
        await ApiServices().updateFcmToken();

        return 'Login Successful'; // Return success status
      } else {
        return 'Login failed. Please check your credentials.'; // Return failure status
      }
    } catch (e) {
      print(e.toString());
      return 'An error occurred. Please try again.'; // Return error status
    } finally {
      // Hide loading animation
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Payment Inquiry
  Future<void> paymentInquiry(String token) async {
    if (!mounted) return; // Check if widget is still mounted

    // Show loading animation for payment inquiry
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('https://nextjs.softravine.com/api/student-salary/');
      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        if (decodedData.isNotEmpty) {
          Salary salary = Salary.fromJson(decodedData[0]);
          if (salary.status == "unpaid") {
            // Show popup for unpaid status and navigate back to Login page
            showSalaryStatusDialog();
          } else {
            // Navigate to home page if paid
            Get.offAll(() => Home()); // Use Get.offAll for navigation
          }
        } else {
          // Handle empty salary data
          Get.offAll(() => Home()); // Navigate to home page
        }
      } else {
        print('Failed to load salaries: ${response.body}');
      }
    } catch (e) {
      print("Error checking payment: $e");
    } finally {
      // Hide loading animation
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Clean up and dispose

  void showSalaryStatusDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("নোটিশ"),
          content: Text("মাসিক বেতন অতি দ্রুত পরিশোধ করে পরীক্ষার প্রবেশপত্র গ্রহণ করুন।(৮ তারিখের পর  App এ প্রবেশ নিষিদ্ধ"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                // Close the dialog and navigate back to the login page
                Navigator.of(context).pop();
                Get.offAll(() => LoginPage()); // Navigate to LoginPage
              },
            ),
          ],
        );
      },
    );
  }


  void showPaymentRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("নোটিশ"),
          content: Text("মাসের ৮ তারিখের মধ্যে বেতন পরিশোধ করে সেবা চালু রাখুন।"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Make sure to call the dispose method for controllers or subscriptions here if you have any
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading animation
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.heightBox,
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.all(20),
              width: 100,
              height: 100,
              color: Colors.white,
              child: Image.asset(
                "assets/schoolnewlogo.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          TextFieldInput(

            textEditingController: emailController,
            hintText: "নাম্বার",
            textInputType: TextInputType.number,
          ),
          TextFieldInput(
            isPass: false,
            textEditingController: passwordController,
            hintText: "পাসওয়ার্ড",
            textInputType: TextInputType.text,
          ),
        OurButton(
          width: double.infinity,
          title: isLoading == false ?"এগিয়ে যান":"please wait",
          BoxColor: Colors.red,
          textColor: Colors.white,
          onpress: () async {
            if (!mounted) return; // Check if the widget is still mounted

            setState(() {
              isLoading = true; // Show loading animation
            });

            // Perform API login
            final result = await loginUser();

            if (result == "Login Successful") {
              if (!mounted) return; // Check again before navigation
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Check()),
              );
            } else {
              if (!mounted) return; // Check again before navigation
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }

            setState(() {
              isLoading = false; // Reset after process completion
            });
          },


        ),

        10.heightBox,
          Row(
            children: [
              'পাসওয়ার্ড মনে নাই?'.text.size(15).make(),
              ' আবার  তৈরি করুন'
                  .text
                  .size(15)
                  .color(Colors.deepOrange)
                  .make()
                  .onTap(() {}), // Add functionality if needed
            ],
          ),
          20.heightBox,
          'অথবা, '.text.makeCentered(),
          10.heightBox,
          OurButton(
            width: double.infinity,
            title: " নতুন তৈরি করুন",
            BoxColor: Color(0xFFE1D3FF),
            textColor: Colors.white,
            onpress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
          ),
        ],
      ).box.padding(EdgeInsets.all(20)).make(),
    );
  }
}
