import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:school_management/common_widgets/common_widget.dart';
import 'package:school_management/models/rutin.dart';
import 'package:school_management/pages/home_page/Home_dart.dart';
import 'package:school_management/servises/api_services.dart';
import 'package:velocity_x/velocity_x.dart';

class RutinPage extends StatefulWidget {
  const RutinPage({super.key});

  @override
  State<RutinPage> createState() => _RutinPageState();
}

class _RutinPageState extends State<RutinPage> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {

    TabController tabController = TabController(length: 5, vsync: this);

    return  RefreshIndicator(
      onRefresh: ()async{
        ApiServices().getStudentInfo();
        ApiServices().getAllStudentAttendense();
        ApiServices().getallNotice();
        ApiServices().getPaylNotice();
        ApiServices().getTeachersInfo();
      },
      child: Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        children: [
      Column(
        children: [
          40.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              Icon(Icons.arrow_back_ios,size: 30,color: Colors.white,).onTap((){
             Get.to(()=>Home());
              }),

              "প্রতিদিন এর রুটিন".text.white.bold.size(30).makeCentered(),
              Icon(Icons.access_time_outlined,color: Colors.white,size: 30,),

            ],
          ).box.size(double.infinity, 80).make(),



          Container(

            height: 50.0,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.9),

              borderRadius: BorderRadius.all(Radius.circular(30.0))
            ),
            child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    color:Colors.red,

                    borderRadius:
                    BorderRadius.all(Radius.circular(30))),
                controller: tabController,
                labelPadding: EdgeInsets.zero,
                isScrollable: false,
                labelColor: Colors.white,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                unselectedLabelColor: Colors.white,
                tabs:[

                  Tab(child: Text('রবি').box.size(68, 40).padding(EdgeInsets.all(10)).make(),),
                  Tab(child: Text('সোম').box.size(60, 40).padding(EdgeInsets.all(7)).make(),),
                  Tab(child: Text('মঙ্গল').box.size(60, 40).padding(EdgeInsets.all(8)).make(),),
                  Tab(child: Text('বুধ').box.size(60, 40).padding(EdgeInsets.all(8)).make()),
                  Tab(child: Text('বৃহস্প').box.size(70, 40).padding(EdgeInsets.all(8)).make(),),

                ]
            ),
          ),

        ],
      ).box.size(double.infinity, 200).color(Colors.red).make(),

      Expanded(
        child:TabBarView(
          controller: tabController,
          children: [


            RefreshIndicator(
            onRefresh: () async {
      // Implement refresh logic here if needed
      },
        child: Container(
          child: FutureBuilder(
            future: ApiServices().getAllRutins(),
            builder: (context, snapshot) {
              // Show loading spinner while fetching the data
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                  ),
                );
              }
              // If there's an error
              else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              // If data is available
              else if (snapshot.hasData) {
                var rutin = snapshot.data as Rutin; // Handle as single Rutin object

                // Extract the Sunday routine
                var sundayRoutine = rutin.sunday ?? [];

                // Check if the Sunday routine list is empty
                if (sundayRoutine.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "কোনো রুটিন তৈরি নেই",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                // If Sunday routine data is not empty, display it
                return ListView.builder(
                  itemCount: sundayRoutine.length,
                  itemBuilder: (context, index) {
                    var routine = sundayRoutine[index];
                    return RutinBox(
                      subject: routine.subject ?? 'No Subject',
                      schedule: "${routine.start} - ${routine.end}",
                      teacherName: routine.teacher ?? 'No Teacher',
                      whichPeriod: routine.period.toString(),
                    );
                  },
                );
              }
              // Fallback case, no data found
              else {
                return Center(
                  child: Text("No routine available."),
                );
              }
            },
          ),
        ),
      ),


      //mondayRutin

          RefreshIndicator(
            onRefresh: () async {
              // Implement refresh logic here if needed
            },
            child: Container(
              child: FutureBuilder(
                future: ApiServices().getAllRutins(),
                builder: (context, snapshot) {
                  // Show loading spinner while fetching the data
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                      ),
                    );
                  }
                  // If there's an error
                  else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  // If data is available
                  else if (snapshot.hasData) {
                    var rutin = snapshot.data as Rutin; // Handle as single Rutin object

                    // Extract the Sunday routine
                    var mondayRoutine = rutin.monday ?? [];

                    // Check if the Sunday routine list is empty
                    if (mondayRoutine.isEmpty) {
                      return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "কোনো রুটিন তৈরি নেই",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    // If Sunday routine data is not empty, display it
                    return ListView.builder(
                      itemCount: mondayRoutine.length,
                      itemBuilder: (context, index) {
                        var routine = mondayRoutine[index];
                        return RutinBox(
                          subject: routine.subject ?? 'No Subject',
                          schedule: "${routine.start} - ${routine.end}",
                          teacherName: routine.teacher ?? 'No Teacher',
                          whichPeriod: routine.period.toString(),
                        );
                      },
                    );
                  }
                  // Fallback case, no data found
                  else {
                    return Center(
                      child: Text("No routine available."),
                    );
                  }
                },
              ),
            ),
          ),



      //tuesday Rutin
            RefreshIndicator(
              onRefresh: () async {
                // Implement refresh logic here if needed
              },
              child: Container(
                child: FutureBuilder(
                  future: ApiServices().getAllRutins(),
                  builder: (context, snapshot) {
                    // Show loading spinner while fetching the data
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                        ),
                      );
                    }
                    // If there's an error
                    else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    // If data is available
                    else if (snapshot.hasData) {
                      var rutin = snapshot.data as Rutin; // Handle as single Rutin object

                      // Extract the Sunday routine
                      var mondayRoutine = rutin.tuesday ?? [];

                      // Check if the Sunday routine list is empty
                      if (mondayRoutine.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "কোনো রুটিন তৈরি নেই",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      // If Sunday routine data is not empty, display it
                      return ListView.builder(
                        itemCount: mondayRoutine.length,
                        itemBuilder: (context, index) {
                          var routine = mondayRoutine[index];
                          return RutinBox(
                            subject: routine.subject ?? 'No Subject',
                            schedule: "${routine.start} - ${routine.end}",
                            teacherName: routine.teacher ?? 'No Teacher',
                            whichPeriod: routine.period.toString(),
                          );
                        },
                      );
                    }
                    // Fallback case, no data found
                    else {
                      return Center(
                        child: Text("No routine available."),
                      );
                    }
                  },
                ),
              ),
            ),



            //wednesday Rutin

            RefreshIndicator(
              onRefresh: () async {
                // Implement refresh logic here if needed
              },
              child: Container(
                child: FutureBuilder(
                  future: ApiServices().getAllRutins(),
                  builder: (context, snapshot) {
                    // Show loading spinner while fetching the data
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                        ),
                      );
                    }
                    // If there's an error
                    else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    // If data is available
                    else if (snapshot.hasData) {
                      var rutin = snapshot.data as Rutin; // Handle as single Rutin object

                      // Extract the Sunday routine
                      var mondayRoutine = rutin.wednesday ?? [];

                      // Check if the Sunday routine list is empty
                      if (mondayRoutine.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "কোনো রুটিন তৈরি নেই",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      // If Sunday routine data is not empty, display it
                      return ListView.builder(
                        itemCount: mondayRoutine.length,
                        itemBuilder: (context, index) {
                          var routine = mondayRoutine[index];
                          return RutinBox(
                            subject: routine.subject ?? 'No Subject',
                            schedule: "${routine.start} - ${routine.end}",
                            teacherName: routine.teacher ?? 'No Teacher',
                            whichPeriod: routine.period.toString(),
                          );
                        },
                      );
                    }
                    // Fallback case, no data found
                    else {
                      return Center(
                        child: Text("No routine available."),
                      );
                    }
                  },
                ),
              ),
            ),

      //thusedayRutin

            RefreshIndicator(
              onRefresh: () async {
                // Implement refresh logic here if needed
              },
              child: Container(
                child: FutureBuilder(
                  future: ApiServices().getAllRutins(),
                  builder: (context, snapshot) {
                    // Show loading spinner while fetching the data
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                        ),
                      );
                    }
                    // If there's an error
                    else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    // If data is available
                    else if (snapshot.hasData) {
                      var rutin = snapshot.data as Rutin; // Handle as single Rutin object

                      // Extract the Sunday routine
                      var mondayRoutine = rutin.thursday ?? [];

                      // Check if the Sunday routine list is empty
                      if (mondayRoutine.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "কোনো রুটিন তৈরি নেই",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      // If Sunday routine data is not empty, display it
                      return ListView.builder(
                        itemCount: mondayRoutine.length,
                        itemBuilder: (context, index) {
                          var routine = mondayRoutine[index];
                          return RutinBox(
                            subject: routine.subject ?? 'No Subject',
                            schedule: "${routine.start} - ${routine.end}",
                            teacherName: routine.teacher ?? 'No Teacher',
                            whichPeriod: routine.period.toString(),
                          );
                        },
                      );
                    }
                    // Fallback case, no data found
                    else {
                      return Center(
                        child: Text("No routine available."),
                      );
                    }
                  },
                ),
              ),
            ),



          ],
        ) ,

      )



        ],
      ),
      ),
    );
  }
}
