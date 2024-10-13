import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:school_management/common_widgets/common_widget.dart';
import 'package:school_management/models/video_lecture_model.dart';
import 'package:school_management/servises/api_services.dart';
import 'package:velocity_x/velocity_x.dart';

class AboutTeacher extends StatelessWidget {
  final String? name;
  final String? img;
  final String? phone;
  final String? subject;

  const AboutTeacher({super.key, this.name, this.img, this.phone, this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

body: Column(
  children: [
    Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      child: Row(

        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(
            img != null ? img! : "assets/teacher (1).png",
            fit: BoxFit.fill,
            scale: 7,
          ).box.white.size(100, 100).clip(Clip.antiAlias).rounded.margin(EdgeInsets.only(top: 23,bottom: 10,left: 10,right: 10)).make(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              name != null ? "$name".text.white.bold.make() : Container(),
              "বিষয় : $subject".text.bold.white.make(),
              "নাম্বার : $phone".text.white.semiBold.make(),

            ],
          ),
          20.widthBox,

          IconButton(onPressed: (){}, icon: Icon(Icons.perm_identity,size: 50,color: Colors.white,))
        ],
      ),
    ),

    Expanded(
      child:Container(

          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(

              color: Colors.white70,


              borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30))
          ),
          child: FutureBuilder(
              future:ApiServices().getVideoLecture() ,
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.blueAccent),),);
                }else if(snapshot.hasData){
                  var data = snapshot.data as List<VideoLectureModel>;
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DirectionButton(text: "সকল লেকচার",icon: Icons.video_library_outlined),

                        Column(
                          children: data.any((item) => item.subject == subject)
                              ? List.generate(data.length, (index) {
                            return data[index].subject == subject
                                ? videoLecture(
                              image: "assets/class1.png",
                              headline: "${data[index].subject}",
                              description: "${data[index].content}",
                              url: "${data[index].url}",
                              releastime: "${data[index].date.toString().substring(0, 10)}",
                            )
                                : SizedBox(); // Don't render anything if it's not a match
                          })
                              : [
                            Column(

                              children: [
                                Center(
                                  child: Container(
                                    child: Icon(
                                      Icons.find_in_page,
                                      color: Colors.grey,
                                      size: 100,
                                    ),
                                  ),
                                ),
                                "ইতিমধ্যে কোনো লেকচার তৈরি করা হয়নাই".text.make(),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                  );
                }else{
                  return Center(child: Text("No video lecture available"));
                }
              })
      ) ,
    )


  ],
),
    );
  }
}
