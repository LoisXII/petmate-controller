import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:petmate_controller/Services/MyServices.dart';
import 'package:petmate_controller/Widgets/LoadingIndicator.dart';
import 'package:petmate_controller/Widgets/MyPhoneNumberTextFieldTemplate.dart';
import 'package:petmate_controller/main.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color2,
        centerTitle: true,
        toolbarHeight: mainh * 0.065,
        title: AutoSizeText(
          MyServices().capitalizeEachWord('test page '),
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: color1,
                fontWeight: FontWeight.bold,
                fontSize: mainh * 0.065 * 0.40,
              ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoadingIndicator(
                backgroundcolor: Colors.white,
              )
              //
            ],
          ),
        ),
      ),
    );
  }
}
