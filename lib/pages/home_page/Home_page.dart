import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/common_widgets/common_widget.dart';
import 'package:school_management/controllers/auth_service.dart';
import 'package:school_management/models/AllTeachers.dart';
import 'package:school_management/models/attendens.dart';
import 'package:school_management/models/notce.dart';
import 'package:school_management/models/notice_model.dart';
import 'package:school_management/models/result_sheet.dart';
import 'package:school_management/models/salary.dart';
import 'package:school_management/pages/auth_screens/login_screen.dart';
import 'package:school_management/pages/notice_page/notice_page.dart';
import 'package:school_management/pages/teachers/about_teacher.dart';
import 'package:school_management/pages/video_lecture_page/video_lecture.dart';
import 'package:school_management/servises/api_services.dart';
import 'package:school_management/servises/notification/notification_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart'; // Add this import for date handling
import 'package:get/get.dart';
class HomePage extends StatefulWidget {

  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<List<Attendens>> attendanceFuture;
  late Future<List<Notice>> noticeFuture;
  late Future<List<Salary>> salaryFuture;
  late Future<List<AllTeachers>> teachersFuture;
  late Future<List<ResultSheet>> resultSheet;



  @override
  void initState() {
    super.initState();
    PushNotifications.getDeviceToken();
    ApiServices().getStudentInfo();

    _loadData(); // Load initial data
  }

  void _loadData() {
    attendanceFuture = ApiServices().getAllStudentAttendense();
    noticeFuture = ApiServices().getallNotice();
    salaryFuture = ApiServices().getPaylNotice();
    teachersFuture = ApiServices().getTeachersInfo();
    resultSheet = ApiServices().getResultInfo();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.blueAccent,
      onRefresh: () async {
        // Reload data when the user pulls to refresh
        setState(() {
          _loadData();
        });
      },
      child: WillPopScope(
        onWillPop: () async {
          // Prevent back navigation
          return false; // Prevents the app from navigating back
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: FutureBuilder(
              future: ApiServices().getStudentInfo(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                    ),
                  );
                }
                var data = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.network(
                            "${data?["img"]}",
                            fit: BoxFit.fill,
                            scale: 7,
                          ).box.white.size(100, 100).clip(Clip.antiAlias).rounded.margin(
                            EdgeInsets.only(top: 23, bottom: 10, left: 10, right: 10),
                          ).make(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              "${data?["name"]}".text.white.bold.make(),
                              "শ্রেণী: ${data?["grade"]}".text.white.semiBold.make(),
                              "রোল:  ${data?["roll"]}".text.white.semiBold.make(),
                              "নাম্বার:  ${data?["phone"]}".text.size(10).white.semiBold.make(),
                            ],
                          ),
                        5.widthBox,
                     TextButton(
                       onPressed: () async {
                         AuthService.logout();
                         final prefs = await SharedPreferences.getInstance();
                         await prefs.remove('token'); // Remove the authentication token
                         // Navigate to LoginPage and remove all previous pages
                         Get.offAll(() => LoginPage());
                       },
                       child: "LogOut".text.white.bold.size(20).make(),
                     )
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DirectionButton(text: "উপস্থিতি", icon: Icons.find_in_page),
                            FutureBuilder<List<Attendens>>(
                              future: attendanceFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasData) {
                                  var attendanceData = snapshot.data!;

                                  if (attendanceData.isEmpty) {
                                    return Container(
                                      padding: EdgeInsets.all(20),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "এটেন্ডেন্স ফাইল তৈরি হয়নি,",
                                        style: TextStyle(color: Colors.black, fontSize: 16),
                                      ),
                                    );
                                  }

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(attendanceData.length, (index) {
                                        return AttendenceBox(
                                          isAttend: attendanceData[index].status == 'present',
                                          date: "${attendanceData[index].date.toString().substring(0, 10)}",
                                        );
                                      }),
                                    ),
                                  );
                                } else {
                                  return Text(
                                    "No attendance data.",
                                    style: TextStyle(color: Colors.black),
                                  );
                                }
                              },
                            ),
                            10.heightBox,
                            DirectionButton(text: "নোটিশ", icon: Icons.notification_add_outlined).onTap(() {
                              Get.to(() => NoticePage());
                            }),
                            FutureBuilder<List<Notice>>(
                              future: noticeFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasData) {
                                  var noticeData = snapshot.data!;
                                  noticeData = noticeData.where((notice) => notice.date != null).toList();
                                  noticeData.sort((a, b) => b.date!.compareTo(a.date!));

                                  return NoticeBoard(text: "${noticeData.isNotEmpty ? noticeData.first.content : 'মাসিক বেতন যথাসময়ে পরিশোধের জন্য ধন্যবাদ।'}");
                                } else {
                                  return Text('Failed to load notices.');
                                }
                              },
                            ),
                            10.heightBox,
                            DirectionButton(text: "মাসিক বেতন নোটিশ", icon: Icons.notification_add_outlined).onTap((){}),
         // Add this import for date handling


                            FutureBuilder<List<Salary>>(
                              future: salaryFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasData) {
                                  var salaryData = snapshot.data!;
                                  var currentDate = DateTime.now(); // Get the current date
                                  var currentDay = currentDate.day; // Get the current day

                                  if (salaryData.isNotEmpty) {
                                    var salaryStatus = salaryData.first.status;

                                    // Check if salary status is 'unpaid'
                                    if (salaryStatus == 'unpaid') {
                                      // Allow the user to stay in the app if the day is less than or equal to 9
                                      if (currentDay <= 9) {
                                        return NoticeBoard(
                                          text: "মাসিক বেতন অতি দ্রুত পরিশোধ করে পরীক্ষার প্রবেশপত্র গ্রহণ করুন।(৮ তারিখের পর তো App এ প্রবেশ নিষিদ্ধ",
                                        );
                                      } else {
                                        // Log the user out automatically if the day is greater than 9
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          Get.defaultDialog(
                                            title: "নোটিশ,",
                                            middleText: "মাসিক বেতন অতি দ্রুত পরিশোধ করে পরীক্ষার প্রবেশপত্র গ্রহণ করুন।(৮ তারিখের পর তো App এ প্রবেশ নিষিদ্ধ"
                                            ,
                                            onConfirm: ()async {
                                              AuthService.logout();
                                              final prefs = await SharedPreferences.getInstance();
                                              await prefs.remove('token'); // Remove the authentication token
                                              // Navigate to LoginPage and remove all previous pages

                                              Get.offAll(() => LoginPage());
                                            },

                                            barrierDismissible: false, // Prevent closing the dialog by tapping outside
                                          );
                                        });
                                        return Container(
                                          child: "মাসিক বেতন অতি দ্রুত পরিশোধ করে পরীক্ষার প্রবেশপত্র গ্রহণ করুন।(৮ তারিখের পর তো App এ প্রবেশ নিষিদ্ধ".text.make(),
                                        ).box
                                            .size(double.infinity,100 )
                                            .rounded
                                            .white
                                            .shadowSm
                                            .padding(EdgeInsets.all(5))
                                            .border(color: Colors.black12,width: 6)
                                            .margin(EdgeInsets.all(10))
                                            .make(); // Return empty container after showing dialog
                                      }
                                    } else {
                                      // Handle the case when salary is 'paid'
                                      return NoticeBoard(
                                        text: "মাসিক বেতন যথাসময়ে পরিশোধের জন্য ধন্যবাদ।",
                                      );
                                    }
                                  } else {
                                    return Container(
                                      child: "মাসিক বেতন অতি দ্রুত পরিশোধ করে পরীক্ষার প্রবেশপত্র গ্রহণ করুন।(৮ তারিখের মধ্যে বেতন পরিশোধ না করলে App এ ঢুকতে পারবেন না)".text.make(),
                                    ).box
                                        .size(double.infinity,100 )
                                        .rounded
                                        .white
                                        .shadowSm
                                        .padding(EdgeInsets.all(5))
                                        .border(color: Colors.black12,width: 6)
                                        .margin(EdgeInsets.all(10))
                                        .make();
                                  }
                                } else if (snapshot.hasError) {
                                  return Container(
                                    child: "মাসিক বেতন অতি দ্রুত পরিশোধ করে পরীক্ষার প্রবেশপত্র গ্রহণ করুন(৮ তারিখের মধ্যে বেতন পরিশোধ না করলে App এ ঢুকতে পারবেন না)".text.make(),
                                  ).box
                                      .size(double.infinity,100 )
                                      .rounded
                                      .white
                                      .shadowSm
                                      .padding(EdgeInsets.all(5))
                                      .border(color: Colors.black12,width: 6)
                                      .margin(EdgeInsets.all(10))
                                      .make();
                                } else {
                                  return Container(
                                    child: "মাসিক বেতন অতি দ্রুত পরিশোধ করে পরীক্ষার প্রবেশপত্র গ্রহণ করুন।(৮ তারিখের মধ্যে বেতন পরিশোধ না করলে App এ ঢুকতে পারবেন না)".text.make(),
                                  ).box
                                      .size(double.infinity,100 )
                                      .rounded
                                      .white
                                      .shadowSm
                                      .padding(EdgeInsets.all(5))
                                      .border(color: Colors.black12,width: 6)
                                      .margin(EdgeInsets.all(10))
                                      .make();
                                }
                              },
                            ),



                            10.heightBox,
                            DirectionButton(text: "শিক্ষকরা", icon: Icons.people_alt_outlined),
                            FutureBuilder<List<AllTeachers>>(
                              future: teachersFuture,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var teacherData = snapshot.data!;

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: List.generate(teacherData.length, (index) {
                                        return teacherData[index].name == "Admin" ? Container(height: 100,width: 300,
                                        child: Center(child: Text("Teacher info update soon")),
                                        ): teacherIntrobox(
                                          image: "${teacherData[index].img}",
                                          name: "${teacherData[index].name}",
                                          subject: "${teacherData[index].subject}",
                                        ).onTap(() {
                                          Get.to(() => AboutTeacher(
                                            name: "${teacherData[index].name}",
                                            img: "${teacherData[index].img}",
                                            phone: "${teacherData[index].phone}",
                                            subject: "${teacherData[index].subject}",
                                          ));
                                        });
                                      }),
                                    ),
                                  );
                                } else {
                                  return Text("শিক্ষক তালিকা দ্রুতই যোগ করা হবে ");
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}
