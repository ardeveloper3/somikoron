import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/models/AllTeachers.dart';
import 'package:school_management/models/attendens.dart';
import 'package:school_management/models/notce.dart';
import 'package:school_management/models/notice_model.dart';
import 'package:school_management/models/result_sheet.dart';
import 'package:school_management/models/rutin.dart';
import 'package:school_management/models/salary.dart';
import 'package:school_management/models/video_lecture_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ApiServices {
  Future<Map<String, dynamic>?> getStudentInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mytoken = prefs.getString('token');

    if (mytoken == null) {
      print('Error: Token not found!');
      return null;
    }

    final url = Uri.parse('https://nextjs.softravine.com/api/student-info/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $mytoken',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('Student Info: $data');
      return data;
    } else if (response.statusCode == 401) {
      print('Error: Unauthorized. Token might be expired.');
      return null;
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return null;
    }
  }
  // Future<void> getStudentInfo() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var mytoken = prefs.getString('token');
  //
  //   final url = Uri.parse('https://nextjs.softravine.com/api/student-info/');
  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Authorization': 'Bearer $mytoken',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     print('Student Info: $data');
  //     return data;
  //   } else {
  //     print('Error: ${response.body}');
  //
  //   }
  // }

//pressentation api services


  //Attendens sheet collection
  Future<Map<String, dynamic>?> getStudentAttendance() async {

    List attendense = [];

    // Retrieve the token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mytoken = prefs.getString('token');

    // Check if token exists
    if (mytoken == null) {
      print('Error: Token not found!');
      return null;
    }

    // Define the API URL for student attendance
    final url = Uri.parse('https://nextjs.softravine.com/api/student-attendance/');

    // Make the GET request with the Authorization header
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $mytoken',
      },
    );

    // Handle the API response
    if (response.statusCode == 200) {

      var data = jsonDecode(response.body);
      for(var attend in data){
        attendense.add(attend);

      }
      print('Student Attendance: $data');
      return data;
    } else if (response.statusCode == 401) {
      print('Error: Unauthorized. Token might be expired.');
      return null;
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return null;
    }
  }


  // Define your base URL or API endpoint
  final String baseUrl = 'https://nextjs.softravine.com/api/';

  Future<List<Attendens>> getAllStudentAttendense() async {
    List<Attendens> allAttendens = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var mytoken = prefs.getString('token');

      // Define the API URL for student attendance
      final url = Uri.parse('${baseUrl}student-attendance/');

      // Make the GET request with the Authorization header
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $mytoken',
        },
      );

      if (response.statusCode == 200) {
        var data = response.body;
        var decodedData = jsonDecode(data);

        for (var newAttenes in decodedData) {
          Attendens newAttend = Attendens.fromJson(newAttenes);
          allAttendens.add(newAttend);
        }

        return allAttendens;  // Make sure to return the list
      } else {
        throw Exception('Failed to load attendance, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

//get all notice

  Future<List<Notice>> getallNotice() async {
    List<Notice> allNotice = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var mytoken = prefs.getString('token');

      // Define the API URL for notices
      final url = Uri.parse('${baseUrl}notices/');

      // Make the GET request with the Authorization header
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $mytoken',
        },
      );

      if (response.statusCode == 200) {
        var data = utf8.decode(response.bodyBytes);  // Decode bytes using UTF-8
        var decodedData = jsonDecode(data);


        // Reverse the decoded data if the newest notices are at the end of the array
        decodedData = decodedData.reversed.toList();

        // Convert each notice JSON object into a Notice instance
        for (var newNotice in decodedData) {
          Notice notice = Notice.fromJson(newNotice);
          allNotice.add(notice);
        }

        print("Successfully fetched notices: ${allNotice.length}"); // Log the count of notices
        return allNotice;  // Return the list of notices
      } else {
        print('Failed to load notices, status code: ${response.statusCode}'); // Log failure
        return []; // Return an empty list instead of throwing
      }
    } catch (e) {
      print('Error fetching notices: ${e.toString()}'); // Log the error
      return []; // Return an empty list in case of error
    }
  }



  //get pay notice
  Future<List<Salary>> getPaylNotice() async {
    List<Salary> allSalary = []; // List to store salaries

    try {
      // Fetch the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var mytoken = prefs.getString('token');

      if (mytoken == null) {
        throw Exception('Token not found! Please log in again.');
      }

      final url = Uri.parse('https://nextjs.softravine.com/api/student-salary/');

      // API call with the token
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $mytoken',
          'Content-Type': 'application/json', // Ensure proper content type
        },
      );

      // Check if the API response is successful
      if (response.statusCode == 200) {
        var data = response.body;
        var decodedData = jsonDecode(data);

        // Ensure that the decoded data is a list
        if (decodedData is List) {
          // Map the JSON data to the Salary model
          for (var newSalary in decodedData) {
            Salary salary = Salary.fromJson(newSalary);
            allSalary.add(salary);
          }
        } else {
          throw Exception('Unexpected data format');
        }

        return allSalary; // Return the list of salaries
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token or session expired.');
      } else {
        // Handle other status codes
        throw Exception(
            'Failed to load salaries. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch and print the error for debugging
      print('Error in getPaylNotice: $e');
      throw Exception('Failed to load salaries: $e');
    }
  }



  //getTeachers Infromation
  Future<List<AllTeachers>> getTeachersInfo() async {
    List<AllTeachers> allTeachers = []; // Renamed for clarity

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var mytoken = prefs.getString('token');
      final url = Uri.parse('https://nextjs.softravine.com/api/teacher-list/');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $mytoken',
        },
      );

      if (response.statusCode == 200) {
        var data = response.body;
        var decodedData = jsonDecode(data);

        for (var newTeacher in decodedData) {
          AllTeachers teacher = AllTeachers.fromJson(newTeacher);
          allTeachers.add(teacher);
        }

        return allTeachers; // Return the list of AllTeachers
      } else {
        throw Exception('Failed to load teachers');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }



  //getResultInfo

  Future<List<ResultSheet>> getResultInfo() async {
    List<ResultSheet> allNotice = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var mytoken = prefs.getString('token');
      final url = Uri.parse('https://nextjs.softravine.com/api/student-result/');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $mytoken',
        },
      );

      if (response.statusCode == 200) {
        var data = response.body;
        var decodedData = jsonDecode(data);

        for (var newNotice in decodedData) {
          ResultSheet notice = ResultSheet.fromJson(newNotice);
          allNotice.add(notice);
        }
        return allNotice; // Ensure you return the list
      } else {
        throw Exception('Failed to load results'); // Handle non-200 responses
      }
    } catch (e) {
      throw Exception(e.toString()); // Rethrow exception for outer handling
    }
  }

  //getAllNotce
  getAllNotce()async{
    List<Notce> allNotice = [];
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var mytoken = prefs.getString('token');
      // Define the API URL for student attendance
      final url = Uri.parse('https://nextjs.softravine.com/api/notes/');

      // Make the GET request with the Authorization header
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $mytoken',
        },
      );


      if(response.statusCode ==200){
        var data = response.body;

        var decodedData = jsonDecode(data);

        for(var newNotice in decodedData){
          Notce notice = Notce.fromJson(newNotice);
          allNotice.add(notice);

        }
        return allNotice;
      }
    }catch(e){

      throw Exception(e.toString());

    }
  }

  //video lecture

  getVideoLecture()async{
    List<VideoLectureModel> allNotice = [];
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var mytoken = prefs.getString('token');
      // Define the API URL for student attendance
      final url = Uri.parse('https://nextjs.softravine.com/api/lectures/');

      // Make the GET request with the Authorization header
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $mytoken',
        },
      );


      if(response.statusCode ==200){
        var data = response.body;

        var decodedData = jsonDecode(data);

        for(var newNotice in decodedData){
          VideoLectureModel notice = VideoLectureModel.fromJson(newNotice);
          allNotice.add(notice);

        }
        return allNotice;
      }
    }catch(e){

      throw Exception(e.toString());

    }
  }

  //get all rutins

  Future<Rutin?> getAllRutins() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var mytoken = prefs.getString('token');

      // Define the API URL for routines
      final url = Uri.parse('https://nextjs.softravine.com/api/routines/');

      // Make the GET request with the Authorization header
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $mytoken',
        },
      );

      if (response.statusCode == 200) {
        var data = response.body;

        // Parse the JSON response
        var decodedData = jsonDecode(data);

        // Convert the response to a Rutin object
        Rutin routine = Rutin.fromJson(decodedData);

        return routine; // Return the Rutin object
      } else {
        throw Exception('Failed to load routines');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
//heere is refresh token
  //this is Apiservice class
  //refresh tokem
  // Future<void> refreshToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final storedRefreshToken = prefs.getString('refreshToken');
  //
  //   final url = Uri.parse('https://nextjs.softravine.com/api/token/refresh/');
  //   var response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'refresh': storedRefreshToken}),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     await prefs.setString('token', data['access']);
  //     await prefs.setString('refreshToken', data['refresh']); // Update if the API sends a new one
  //   } else {
  //     // Handle error or token expiration
  //     print('Token refresh failed');
  //     Get.snackbar('Error', 'Session expired. Please login again.');
  //   }
  // }
  //
  //

//updatetoke
  final String fcmtokenUrl = "https://nextjs.softravine.com/api/update-fcm-token/";

  Future<void> updateFcmToken() async {
    // Retrieve the student token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final String? studentToken = prefs.getString('token');
    final String? deviceToken = prefs.getString('deviceToken');


    if (studentToken == null) {
      print('Student token not found in SharedPreferences.');
      return; // Handle the absence of the token as needed
    }

    final url = Uri.parse(fcmtokenUrl);
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $studentToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'fcm_token': deviceToken,
      }),
    );

    if (response.statusCode == 200) {
      print('FCM token updated successfully: ${response.body}');
      
    } else {
      print('Failed to update FCM token: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to update FCM token');
    }
  }

}