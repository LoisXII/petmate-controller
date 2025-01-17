import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:petmate_controller/Services/MyServices.dart';
import 'package:petmate_controller/Widgets/MyBackButtonTemplate.dart';
import 'package:petmate_controller/Widgets/MyButtonTemplate.dart';
import 'package:petmate_controller/Widgets/MyTextFormFieldTemplate.dart';
import 'package:petmate_controller/main.dart';
import 'package:petmate_controller/models/UserLoginModel.dart';
import 'package:petmate_controller/pages/HomePage.dart';
import 'package:petmate_controller/providers/FirebaseProvider.dart';
import 'package:petmate_controller/providers/LocalFunctionProvider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const MyBackButtonTemplate(),
        backgroundColor: color2,
        toolbarHeight: mainh * 0.065,
        title: AutoSizeText(
          MyServices().capitalizeEachWord('login page'),
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
        color: Colors.grey[50],
        child: SingleChildScrollView(
          child: Column(
            children: [
              // animation .
              DisplayAnimation(),

              // email textfield .
              DisplayEmailTextField(),

              // password textfield .
              DisplayPasswordTextField(),

              // login button
              DisplayLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget DisplayAnimation() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Container(
      width: mainw,
      height: mainh * .55,
      child: Lottie.asset('lotties/login_new.json'),
    );
  }

  Widget DisplayPasswordTextField() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<LocalFunctionProvider>(
      builder: (context, functions, child) => MyTextFormFieldTemplate(
        top: mainh * 0.02,
        controller: functions.password_controller_login,
        height: mainh * 0.06,
        border_color: color4,
        textInputType: TextInputType.visiblePassword,
        text: MyServices().capitalizeEachWord('password'),
        textStyle: Theme.of(context)
            .textTheme
            .headlineLarge!
            .copyWith(color: color1, fontSize: mainh * 0.06 * .40),
        width: mainw * .95,
      ),
    );
  }

  Widget DisplayEmailTextField() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<LocalFunctionProvider>(
      builder: (context, functions, child) => MyTextFormFieldTemplate(
        top: mainh * 0.02,
        height: mainh * 0.06,
        controller: functions.email_controller_login,
        textInputType: TextInputType.emailAddress,
        text: MyServices().capitalizeEachWord('email'),
        textStyle: Theme.of(context)
            .textTheme
            .headlineLarge!
            .copyWith(color: color1, fontSize: mainh * 0.06 * .40),
        width: mainw * .95,
      ),
    );
  }

  Widget DisplayLoginButton() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return MyButtonTemplate(
        top: mainh * 0.05,
        height: mainh * 0.055,
        backgroundColor: color3,
        onPressed: () {
          LoginFunctionButton();
        },
        radius: 5,
        text: MyServices().capitalizeEachWord('login'),
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Colors.white,
              fontSize: mainh * 0.055 * .6,
              fontWeight: FontWeight.bold,
            ),
        width: mainw * 0.95);
  }

  Future LoginFunctionButton() async {
    // get firebase provider .
    FirebaseProvider firebase = context.read<FirebaseProvider>();
    // get localFunctions provider
    LocalFunctionProvider functions = context.read<LocalFunctionProvider>();

    // get controllers .
    // email
    String email = functions.email_controller_login.text.toLowerCase().trim();
    // password
    String password =
        functions.password_controller_login.text.toLowerCase().trim();

    // check  there is no empty values .
    bool isEmailvalid = email.isNotEmpty == true &&
            email.contains('@') == true &&
            email.contains('.com')
        ? true
        : false;
    bool isPasswordvalid =
        password.isNotEmpty == true && password.length >= 8 ? true : false;

    // run function to login .
    if (isEmailvalid && isPasswordvalid) {
      // show loading .
      MyServices().ShowLoading(context: context);
      //
      print(
          "isEmailvalid :$isEmailvalid  , isPasswordvalid : $isPasswordvalid ");

      //run function to login .
      UserLoginModel store_info =
          await firebase.LoginFunction(email: email, password: password);

      // check the login function result .

      // the user exists and passwrod is match !
      if (store_info.exists == true && store_info.user_id != null) {
        // save the data login .
        await context
            .read<LocalFunctionProvider>()
            .SaveLogin(email: email, password: password);

        // going to home page .
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(child: HomePage(), type: PageTransitionType.fade),
          (route) => false,
        );
      }
      // user not found or password not match !
      else {
        // close the loading .
        MyServices().HideSheet(context: context);

        // show notification .
        MyServices().ShowNotificationSheet(
          context: context,
          type: Notification_Type.wronge,
          message: store_info.exists == false &&
                  store_info.user_login_status_enum ==
                      UserLoginStatusEnum.user_notfound
              ? MyServices().capitalizeEachWord('the user not found !')
              : store_info.exists == false &&
                      store_info.user_login_status_enum ==
                          UserLoginStatusEnum.password_notmatch
                  ? MyServices()
                      .capitalizeEachWord('the user\'s password invalid !')
                  : MyServices().capitalizeEachWord('invalid data !'),
          action: () {},
        );
      }

      //
      print(
          "the user login info : ${store_info.exists} , ${store_info.user_login_status_enum}");
    }

    // show notification to show the reasons .
    else {
      //
      print(
          "there is something invalid please check it : email ${isEmailvalid} , password : ${isPasswordvalid}");
      // show notificaion.
      MyServices().ShowNotificationSheet(
        context: context,
        type: Notification_Type.alert,
        message: isEmailvalid == false
            ? MyServices().capitalizeEachWord(
                'the email is invalid pelase check the email formate !')
            : isPasswordvalid == false
                ? MyServices().capitalizeEachWord(
                    'the password must be bigger or equal than 8 char !')
                : MyServices().capitalizeEachWord('something wronge !'),
        action: () {},
      );
    }
  }
}
