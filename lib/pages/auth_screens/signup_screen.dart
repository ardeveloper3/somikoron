import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_management/common_widgets/common_widget.dart';
import 'package:school_management/common_widgets/text_field.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isSigned = false;

  var nameController = TextEditingController();
  var classController = TextEditingController();
  var numberController = TextEditingController();
  var passwordController = TextEditingController();

  String? pickedImagePath;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        pickedImagePath = pickedFile.path;
      });
    }
  }

  Future<void> registration() async {
    setState(() {
      isSigned = true;
    });

    if (nameController.text.isNotEmpty &&
        classController.text.isNotEmpty &&
        numberController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        pickedImagePath != null) {

      await createStudent(
        name: nameController.text,
        phone: numberController.text,
        grade: classController.text,
        password: passwordController.text,
        img: pickedImagePath!,
        context: context,
      );

    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("All fields, including the image, are required!"),
            actions: [
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
  }

  Future<void> createStudent({
    required String name,
    required String phone,
    required String grade,
    required String password,
    required String img,
    required BuildContext context,
  }) async {
    try {
      final url = Uri.parse('https://nextjs.softravine.com/api/create-student/');

      var request = http.MultipartRequest('POST', url);
      request.fields['name'] = name;
      request.fields['phone'] = phone;
      request.fields['grade'] = grade;
      request.fields['password'] = password;

      var file = await http.MultipartFile.fromPath('img', img);
      request.files.add(file);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Student registration successful! Please login."),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/login", (route) => false);
                  },
                ),
              ],
            );
          },
        );
      } else {
        throw Exception("Failed to register student: ${response.body}");
      }
    } catch (e) {
      print('Error during registration: $e');
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Error: ${e.toString()}"),
            actions: [
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.heightBox,
            Row(
              children: [
                CircullerArrow(
                    color: Colors.white,
                    width: 40.0,
                    height: 60.0,
                    BoxColor: Colors.transparent,
                    child: Icon(Icons.arrow_back),
                    onpress: () {
                      Get.back();
                    }),
                60.widthBox,
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.all(5),
                    width: 80,
                    height: 80,
                    color: Colors.white,
                    child: Image.asset(
                      "assets/schoolnewlogo.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            20.heightBox,
            TextFieldInput(
                textEditingController: nameController,
                hintText: "নাম",
                textInputType: TextInputType.text),
            TextFieldInput(
                textEditingController: classController,
                hintText: "শ্রেণি",
                textInputType: TextInputType.text),
            TextFieldInput(
                textEditingController: numberController,
                hintText: "নাম্বার",
                textInputType: TextInputType.number),
            TextFieldInput(
              textEditingController: passwordController,
              hintText: "পাসওয়ার্ড",
              textInputType: TextInputType.text,
              icon: Icons.visibility,
              suffixIconColor: Colors.lightBlueAccent,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          color: Colors.black12,
                          size: 30,
                        ),
                        SizedBox(width: 8),
                        Text(pickedImagePath != null
                            ? "Image Selected"
                            : "Pick Image"),
                      ],
                    ),
                  ),
                ),
                if (pickedImagePath != null)
                  Positioned(
                    right: 10,
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
              ],
            ),
            30.heightBox,
            OurButton(
              width: double.infinity,
              title: isSigned ? "Please wait...." : "নতুন পরিচয় পত্র তৈরি করুন",
              BoxColor: Colors.red,
              textColor: Colors.white,
              onpress: () async {
                if (!isSigned) {
                  await registration();
                }
              },
            ),
            20.heightBox,
            Row(
              children: [
                'যদি আপনার পরিচয় পত্র থাকে তাহলে?'.text.size(15).makeCentered(),
                "লগিন করুন".text.color(Colors.deepOrange).size(15).make(),
              ],
            ).onTap(() {
              Get.back();
            }),
            10.heightBox,
          ],
        ).box.padding(EdgeInsets.all(20)).make(),
      ),
    );
  }
}
