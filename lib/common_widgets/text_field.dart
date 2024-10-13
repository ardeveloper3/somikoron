import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class TextFieldInput extends StatelessWidget {
  final Color? suffixIconColor;
  final TextEditingController textEditingController;
  final bool isPass;
  final VoidCallback? priffixIconButton;
  final String hintText;
  final IconData? icon;
  final IconData? preffixicon;
  final Color? preffixIconColor;
  final TextInputType textInputType;
  final VoidCallback? OnTap;
  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    this.icon,
    required this.textInputType,
    this.suffixIconColor, this.preffixicon, this.preffixIconColor, this.priffixIconButton, this.OnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10,),
      child: TextField(
        style: const TextStyle(fontSize: 20),
        controller: textEditingController,
        decoration: InputDecoration(
          prefixIcon: Icon(preffixicon,color:preffixIconColor ,).onTap(priffixIconButton),
          suffixIcon: Icon(icon, color: suffixIconColor, ).onTap(OnTap),

          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black45, fontSize: 18),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(30),
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
        ),
        keyboardType: textInputType,
        obscureText: isPass,

      ),

    );
  }
}