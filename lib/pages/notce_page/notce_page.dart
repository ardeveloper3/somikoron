import 'package:flutter/material.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:school_management/common_widgets/common_widget.dart';
import 'package:school_management/models/notce.dart';
import 'package:school_management/servises/api_services.dart';
import 'package:velocity_x/velocity_x.dart';


class NotcePage extends StatelessWidget {
  const NotcePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  RefreshIndicator(

      onRefresh: ()async{
    await ApiServices().getAllNotce();
      },
      child: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: Icon(Icons.arrow_back_ios,color: Colors.white,size: 35,),
          title:Row(

            children: [
              "নোটস".text.white.bold.size(24).make(),
              Icon(Icons.local_library_sharp,color: Colors.white,size: 30,)
            ],
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
                child:Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(

                    color: Colors.white70,


                    borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30))
                  ),
                  child:FutureBuilder(
                    future: ApiServices().getAllNotce(),
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
                        var data = snapshot.data as List<Notce>;

                        // Check if the data list is empty
                        if (data.isEmpty) {
                          return Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "কোনো নোটস তৈরি হয়নি",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        }

                        // If data is not empty, display it
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: List.generate(data.length, (index) {
                              return NotceBox(
                                subject: "${data[index].subject}",
                                lecturesubject: "${data[index].content}",
                                assignData: "${data[index].date.toString().substring(0, 10)}",
                                url: "${data[index].pdf}",
                              );
                            }),
                          ),
                        );
                      }
                      // Fallback case, no data found
                      else {
                        return Center(
                          child: Text("There is no data available."),
                        );
                      }
                    },
                  ),

                ) ,
            ),
          ],
        ),
      ),
    );
  }
}
