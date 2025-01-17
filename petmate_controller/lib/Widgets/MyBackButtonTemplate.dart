import 'package:flutter/material.dart';
import 'package:petmate_controller/main.dart';

class MyBackButtonTemplate extends StatelessWidget {
  const MyBackButtonTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return IconButton(
        onPressed: () {
          //
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: color1,
          size: mainh * .065 * .55,
        ));
  }
}
