import 'package:flutter/material.dart';
import 'package:school_management/common_widgets/common_widget.dart';
import 'package:school_management/models/video_lecture_model.dart';
import 'package:school_management/servises/api_services.dart';
import 'package:velocity_x/velocity_x.dart';

class VideoLecture extends StatelessWidget {
  const VideoLecture({super.key});

  @override
  Widget build(BuildContext context) {
    return  RefreshIndicator(
      onRefresh: ()async{
 await ApiServices().getVideoLecture();

      },
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: Icon(Icons.arrow_back_ios,color: Colors.white,size: 35,),
          title: Row(

            children: [
              "ভিডিও  লেকচার".text.white.bold.size(24).make(),
              10.widthBox,
              Icon(Icons.video_library_outlined,color: Colors.white,size: 30,)
            ],
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.red,
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
                  future: ApiServices().getVideoLecture(),
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
                      var data = snapshot.data as List<VideoLectureModel>;

                      // Check if the data list is empty
                      if (data.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "কোনো ভিডিও লেকচার তৈরি নেই",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      // If data is not empty, display it
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: List.generate(data.length, (index) {
                            return videoLecture(
                              image: "assets/class1.png",
                              headline: "${data[index].subject}",
                              description: "${data[index].content}",
                              url: "${data[index].url}",
                              releastime: "${data[index].date.toString().substring(0, 10)}",
                            );
                          }),
                        ),
                      );
                    }
                    // Fallback case, no data found
                    else {
                      return Center(
                        child: Text("No video lecture available."),
                      );
                    }
                  },
                )

              ) ,
            ),
          ],
        ),
      ),
    );
  }
}
