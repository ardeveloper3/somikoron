import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/common_widgets/common_widget.dart';
import 'package:school_management/models/result_sheet.dart';
import 'package:school_management/servises/api_services.dart';
 // Import Notification Service
import 'package:velocity_x/velocity_x.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<ResultSheet>? previousResults;
  Future<List<ResultSheet>>? futureResults; // Store the future here

  @override
  void initState() {
    super.initState();
    // Initialize Notification Service
    futureResults = _refreshData(); // Initialize the future with refresh data
  }

  Future<List<ResultSheet>> _refreshData() async {
    return await ApiServices().getResultInfo(); // Fetch results
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        setState(() {
          futureResults = _refreshData(); // Update the future for the FutureBuilder
        });
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.heightBox,
                    "ফলাফল".text.size(22).white.bold.make().marginOnly(left: 10.0, top: 10),
                    15.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        resultBox(text: "তারিখ"),
                        resultBox(text: "বিষয়"),
                        resultBox(text: "মার্কসিট"),
                        resultBox(text: "অবস্থান"),
                        resultBox(text: "মূল্যায়ন"),
                        resultBox(text: "সর্বোচ্চ"),
                      ],
                    ),
                  ],
                ),
              ),
              10.heightBox,
              FutureBuilder<List<ResultSheet>>(
                future: futureResults, // Use the stored future
                builder: (context, snapshot) {
                  // Show loading indicator
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                      ),
                    );
                  }
                  // Show error message
                  else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  // Show results when available
                  else if (snapshot.hasData) {
                    var data = snapshot.data!;

                    // Check if data is empty
                    if (data.isEmpty) {
                      return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "কোনো রেজাল্ট শিট তৈরি হয়নি পরবর্তী পরিক্ষার পর সংযুক্ত করা হবে",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    // Update previousResults with current data
                    previousResults = data;

                    // Show the result sheet
                    return Column(
                      children: List.generate(data.length, (index) {
                        return marksheet(
                          date: "${data[index].exam?.date.toString().substring(0, 10)}",
                          subject: "${data[index].exam?.subject}",
                          marks: "${data[index].examMarks}/${data[index].exam?.totalMarks}",
                          position: "${data[index].position}",
                          value:  "${data[index].symbol}",
                          heighstmark:  "${data[index].highestExamMarks}",

                        );
                      }),
                    );
                  }
                  // Default message if no data is found
                  else {
                    return Center(
                      child: Text("কোনো রেজাল্ট শিট তৈরি হয়নি পরবর্তী পরিক্ষার পর সংযুক্ত করা হবে"),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
