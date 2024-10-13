import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:school_management/pages/home_page/Home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

Widget DirectionButton({text,icon}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      "$text".text.white.make(),
      10.widthBox,
      Icon(icon,size: 20,color: Colors.white,)
    ],
  )
      .box
  .rounded
  .color(Colors.red)
.size(200, 40)
  .margin(EdgeInsets.all(10))
      .make();
}

Widget AttendenceBox({isAttend,date}){
  return Column(
    children: [


     isAttend ==true ?Icon(Icons.check,color: Colors.green,size: 40,):Icon(Icons.close,color: Colors.red,size: 40,),

      10.heightBox,

      Divider(thickness: 2,),

      "$date".text.make(),
    ],
  ).box
  .size(100, 100)
      .rounded
  .white
  .shadowSm
  .border(color: Colors.black12,width: 6)
  .margin(EdgeInsets.all(10))
      .make();
}

Widget NoticeBoard({text}){
  return "$text".text.size(20).makeCentered().box
      .size(double.infinity,100 )
      .rounded
      .white
      .shadowSm
  .padding(EdgeInsets.all(5))
      .border(color: Colors.black12,width: 6)
      .margin(EdgeInsets.all(10))
      .make();
}

Widget teacherIntrobox({image ,name,subject}){
  return Column(
    children: [
      Image.network("$image",fit: BoxFit.fill,).box.size(100, 80).rounded.clip(Clip.antiAlias).make(),

      Divider(thickness: 2,),
      "$name".text.size(10).make(),
      "$subject".text.bold.make()
    ],
  ).box
      .size(100, 140)
      .rounded
      .white
      .shadowSm

      .margin(EdgeInsets.all(10))
      .make();
}

Widget resultBox({text}){
  return Column(
    children: [
      "$text".text.white.bold.make(),
      Container(
        width: 40,
        height: 3,
        color: Colors.white,
        margin: EdgeInsets.all(5),
      )
    ],
  );
}

Widget marksheet({date, subject, marks, position,value,heighstmark}){
  return Column(
    children: [
      Row(

        children: [
          10.widthBox,
          "$date".text.size(18).make().box.size(45, 40).padding(EdgeInsets.all(3)).make(),

          8.widthBox,
          Container(
            color: Colors.black12,
            width: 3,
            height: 30,
          ),
          5.widthBox,
          "$subject".text.size(18).make().box.size(40, 35).padding(EdgeInsets.only(bottom: 2,top: 2)).make(),
          5.widthBox,
          Container(
            color: Colors.black12,
            width: 3,
            height: 30,
          ),
          7.widthBox,
          "$marks".text.size(16).make().box.size(55, 40).padding(EdgeInsets.only(top: 5,)).make(),
      5.widthBox,
          Container(
            color: Colors.black12,
            width: 3,
            height: 30,
          ),
          12.widthBox,
          "$position".text.size(20).make().box.size(36, 40).padding(EdgeInsets.all(3)).make(),

          Container(
            color: Colors.black12,
            width: 3,
            height: 30,
          ),
         10.widthBox,
          "$value".text.size(20).make().box.size(40, 40).padding(EdgeInsets.all(3)).make(),
          Container(
            color: Colors.black12,
            width: 3,
            height: 30,
          ),
          15.widthBox,
          "$heighstmark".text.size(20).make().box.size(36, 40).padding(EdgeInsets.all(5)).make(),


        ],

      ),
      Divider(
        thickness: 1,
      ),
    ],
  );
}

Widget noticpageBox({fromPeron, date, noticeText}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "$fromPeron".text.size(20).bold.make(),
            "$date".text.color(Colors.grey.withOpacity(0.5)).bold.make(),
          ],
        ),
        Icon(Icons.notifications_active,color: Colors.black12,size: 40,)
      ],
    ),

      10.widthBox,
      Container(
        padding: EdgeInsets.only(top: 10,bottom: 10),
        child:// Wrapping the text widget to handle overflow and context alignment might help.
        "$noticeText".text.color(Colors.grey).size(20).bold.ellipsis.make().box.p8.roundedSM.make(),

      )

    ],
  ).box.width(double.infinity).rounded.padding(EdgeInsets.all(10)).margin(EdgeInsets.all(8)).white.make();
}

Widget RutinBox({subject, schedule, teacherName, whichPeriod}){
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "$subject".text.size(21).bold.make(),
              10.heightBox,
              "$schedule".text.color(Colors.grey.withOpacity(0.5)).make(),
            ],
          ),
          Icon(Icons.co_present,color: Colors.grey.withOpacity(0.5),size: 30,)
        ],
      ),
      Divider(),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          "$teacherName".text.make(),
          " পিরিয়ড $whichPeriod".text.bold.make(),
        ],
      )
    ],
  ).box.white.rounded.padding(EdgeInsets.all(10)).margin(EdgeInsets.all(10)).size(double.infinity, 150).make();
}

Widget NotceBox({
  subject,
  lecturesubject,
  assignData,
  url
}){

  void _launchVideo()async{
    final link = "${url}";
    await launchUrl(
      Uri.parse(link),
      mode: LaunchMode.externalApplication,
    );
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
"$subject".text.bold.makeCentered().box.color(Colors.redAccent.withOpacity(0.6)).rounded.size(100, 30).make(),
      10.heightBox,
      "$lecturesubject".text.bold.size(20).make(),
      10.heightBox,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          "PDF তৈরির তারিখ".text.color(Colors.grey).make(),
          "$assignData".text.bold.make()
        ],
      ),
      20.heightBox,
      Center(
        child: Container(

          width: 170,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          child: "ভিউ PDF ফাইল".text.white.bold.makeCentered().onTap((){
     _launchVideo();
          }),

        ),
      )
    ],
  ).box.white.shadowSm.rounded.padding(EdgeInsets.all(10)).margin(EdgeInsets.all(10)).size(double.infinity, 220).make();
}


class videoLecture extends StatelessWidget {

  final String? image;
  final String? headline;
  final String? description;
  final String? url;
  final String? releastime;


  const videoLecture({super.key, this.image, this.headline, this.description, this.url, this.releastime});

  @override
  Widget build(BuildContext context) {


    void _launchVideo()async{
      final link = "${url}";
      await launchUrl(
        Uri.parse(link),
        mode: LaunchMode.externalApplication,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(

          height: 120,


          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                  image:AssetImage('$image'),
                  fit: BoxFit.cover
              )
          ),
          child: Center(
            child: Icon(Icons.play_arrow,color: Colors.black,size: 40,).box.size(70, 70).color(Colors.white.withOpacity(0.7)).roundedFull.clip(Clip.antiAlias).make(),
          ),
        ).onTap((){
          _launchVideo();
        }),



        //TODO
        //in time of backend you have creat a web view system methode

        "$headline".text.bold.size(20).make().marginOnly(left: 10.0),
        8.heightBox,
        "$description".text.make().marginOnly(left: 10.0),
        8.heightBox,
        "$releastime".text.color(Colors.grey.withOpacity(0.5)).make().marginOnly(left: 10.0),
        10.heightBox,
        Center(
          child: Container(

            width: 280,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                "চলো দেখে আসি".text.white.bold.makeCentered(),
                5.widthBox,
                Icon(Icons.video_library_outlined,color: Colors.white,
                )
              ],
            ),
          ).onTap((){
            _launchVideo();
          }),

        )
      ],
    )
        .box

        .white
    .shadowSm
        .rounded
        .padding(EdgeInsets.only(bottom: 20, ))
        .margin(EdgeInsets.only(bottom: 20.0,left: 10,right: 10))
        .make();
  }
}

Widget OurButton({BoxColor, textColor, onpress, String? title,width}) {
  return Container(
    width: width,
    height: 70,

    decoration: BoxDecoration(

        color: BoxColor, borderRadius: BorderRadius.all(Radius.circular(30))),
    child: "$title".text.bold.color(textColor).makeCentered(),
  ).onTap(onpress);
}

Widget SmallButton({String? image, onpress}) {
  return Image.asset(
    "$image",
    width: 45,
    height: 45,
  ).centered()
      .box
      .shadowSm
      .white
      .margin(EdgeInsets.all(10))
      .size(140, 80)
      .rounded
      .clip(Clip.antiAlias)
      .make()
      .onTap(onpress);
}

Widget CircullerArrow({Color? color, onpress, BoxColor, child, width, height}) {
  return Center(
      child: Container(
        child: child,
      )
          .box
          .color(BoxColor)
          .roundedFull
          .size(width, height)
          .margin(EdgeInsets.all(10))
          .border(color: Colors.black12)
          .make())
      .onTap(onpress);
}
