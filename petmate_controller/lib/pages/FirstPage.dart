import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:petmate_controller/Services/MyServices.dart';
import 'package:petmate_controller/Widgets/LoadingIndicator.dart';
import 'package:petmate_controller/Widgets/MyBackButtonTemplate.dart';
import 'package:petmate_controller/Widgets/MyButtonTemplate.dart';
import 'package:petmate_controller/main.dart';
import 'package:petmate_controller/pages/LoginPage.dart';
import 'package:petmate_controller/pages/RegisterNewStore.dart';
import 'package:petmate_controller/providers/LocalFunctionProvider.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    context.read<LocalFunctionProvider>().CheckLoginData(context: context);

    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: color2,
          toolbarHeight: mainh * 0.065,
          centerTitle: true,
          title: AutoSizeText(
            MyServices().capitalizeEachWord('pet mate admin'),
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: color1,
                  fontWeight: FontWeight.bold,
                  fontSize: mainh * 0.065 * 0.40,
                ),
          ),
        ),
        body: context.watch<LocalFunctionProvider>().checked == false
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey[50],
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // animations .
                      DisplayFirstPageAnimation(),

                      // login button .
                      DisplayLoginButton(),

                      // register button .
                      DisplayRegisterButton(),

                      //
                    ],
                  ),
                ),
              )
            : Center(
                child: LoadingIndicator(),
              ));
  }

  Widget DisplayRegisterButton() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return MyButtonTemplate(
        top: mainh * 0.02,
        radius: 5,
        backgroundColor: color3,
        height: mainh * 0.07,
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: mainh * 0.07 * .45,
            ),
        onPressed: () {
          //
          Navigator.push(
              context,
              PageTransition(
                  child: RegisterNewStore(), type: PageTransitionType.fade));
        },
        text: MyServices().capitalizeEachWord('register'),
        width: mainw * 0.85);
  }

  Widget DisplayLoginButton() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return MyButtonTemplate(
        top: mainh * 0.02,
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: mainh * 0.07 * .45,
            ),
        radius: 5,
        backgroundColor: color4,
        height: mainh * 0.07,
        onPressed: () {
          //
          Navigator.push(
              context,
              PageTransition(
                  child: LoginPage(), type: PageTransitionType.fade));
        },
        text: MyServices().capitalizeEachWord('login'),
        width: mainw * 0.85);
  }

  Widget DisplayFirstPageAnimation() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Container(
      width: mainw,
      height: mainh * .55,
      child: Lottie.asset('lotties/welcome.json'),
    );
  }
}
