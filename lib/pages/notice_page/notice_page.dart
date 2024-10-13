import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:school_management/common_widgets/common_widget.dart';
import 'package:school_management/models/notice_model.dart';
import 'package:school_management/servises/api_services.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<Notice> noticeList = [];
  int? lastNoticeCount; // To store the last notice count

  @override
  void initState() {
    super.initState();

    fetchNotices();

  }

  Future<void> fetchNotices() async {
    var newNotices = await ApiServices().getallNotice();
    setState(() {
      noticeList = newNotices;
    });
  }
  Map payload ={};
  @override
  Widget build(BuildContext context) {


    final data = ModalRoute.of(context)!.settings.arguments;

    if(data is RemoteMessage){
      payload = data.data;
    }

    if(data is NotificationResponse){
      payload = jsonDecode(data.payload!);
    }
    return RefreshIndicator(
      onRefresh: fetchNotices,
      child: Scaffold(
        backgroundColor: Colors.red,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  "নোটিশ".text.white.bold.size(30).make(),
                  100.widthBox,
                  Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                    size: 50,
                  ),
                ],
              ),
            ).box.border(color: Colors.white, width: 3).clip(Clip.antiAlias).rounded.make(),
            Expanded(
              child: FutureBuilder<List<Notice>>(
                future: ApiServices().getallNotice(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    var data = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: List.generate(data.length, (index) {
                          return noticpageBox(
                            fromPeron: "প্রধান শিক্ষক",
                            date: "${data[index].date.toString().substring(0, 10)}",
                            noticeText: "${data[index].content}",
                          );
                        }),
                      ),
                    );
                  } else {
                    return Text("There is no data here");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
