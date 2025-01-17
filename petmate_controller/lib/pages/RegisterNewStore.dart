import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:petmate_controller/Services/MyServices.dart';
import 'package:petmate_controller/Widgets/MyBackButtonTemplate.dart';
import 'package:petmate_controller/Widgets/MyButtonTemplate.dart';
import 'package:petmate_controller/Widgets/MyTextFormFieldTemplate.dart';
import 'package:petmate_controller/main.dart';
import 'package:petmate_controller/pages/FirstPage.dart';
import 'package:petmate_controller/pages/LoginPage.dart';
import 'package:petmate_controller/providers/FirebaseProvider.dart';
import 'package:petmate_controller/providers/LocalFunctionProvider.dart';
import 'package:provider/provider.dart';

class RegisterNewStore extends StatefulWidget {
  const RegisterNewStore({super.key});

  @override
  State<RegisterNewStore> createState() => _RegisterNewStoreState();
}

class _RegisterNewStoreState extends State<RegisterNewStore> {
  //
  @override
  void initState() {
    // load countries .
    context.read<LocalFunctionProvider>().LoadCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: const MyBackButtonTemplate(),
        backgroundColor: color2,
        centerTitle: true,
        toolbarHeight: mainh * 0.065,
        title: AutoSizeText(
          MyServices().capitalizeEachWord('register store'),
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
              // Store animation .
              DisplayStoreAnimation(),

              // owner name textfield .
              DisplayOwnerUserNameTextField(),

              // display Store name textfield .
              DisplayStoreName(),

              // email textfield .
              DisplayEmailTextField(),

              // country .
              Country(),

              // Owner phone number
              PhoneNumber(),

              // password textfield .
              DisplayPasswordTextField(),

              // register button .
              DisplayRegisterButton(),

              // space .
              SizedBox(
                width: mainw,
                height: mainh * 0.05,
              )

              //
            ],
          ),
        ),
      ),
    );
  }

  Widget DisplayRegisterButton() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<FirebaseProvider>(
      builder: (context, firebase, child) => Consumer<LocalFunctionProvider>(
        builder: (context, functions, child) => MyButtonTemplate(
          top: mainh * 0.02,
          radius: 5,
          height: mainh * 0.07,
          onPressed: () {
            RegisterButtonFunction();
          },
          backgroundColor: color3,
          text: MyServices().capitalizeEachWord('register'),
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: mainh * 0.07 * .55,
              ),
          width: mainw * .95,
        ),
      ),
    );
  }

  Widget Country() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<LocalFunctionProvider>(
      builder: (context, value, child) => GestureDetector(
        onTap: () {
          MyServices().ShowCountrySheet(context: context);
        },
        child: Container(
          margin: EdgeInsets.only(top: mainh * .02),
          width: mainw * .95,
          height: mainh * 0.06,
          padding: EdgeInsets.symmetric(horizontal: mainw * 0.01),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: 2,
                color: color4,
              )),
          child: AutoSizeText(
            MyServices().capitalizeEachWord(
                'country : ${value.countryModel != null ? "${value.countryModel!.country_name} ${value.countryModel!.country_flag} " : "---"}'),
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: color1,
                  fontSize: mainh * 0.06 * .4,
                ),
          ),
        ),
      ),
    );
  }

  Widget DisplayStoreAnimation() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Container(
      width: mainw,
      height: mainh * .35,
      child: Lottie.asset('lotties/store.json'),
    );
  }

  Widget DisplayPasswordTextField() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<LocalFunctionProvider>(
      builder: (context, functions, child) => MyTextFormFieldTemplate(
        top: mainh * 0.02,
        height: mainh * 0.06,
        controller: functions.password_controller_registeration,
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

  Widget PhoneNumber() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<LocalFunctionProvider>(
      builder: (context, functions, child) => MyTextFormFieldTemplate(
        height: mainh * 0.06,
        controller: functions.number_controller_registeration,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        textInputType: TextInputType.number,
        top: mainh * 0.02,
        isphonenumber: true,
        text: "phone number",
        textStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: color1,
              fontSize: mainh * 0.06 * 0.4,
            ),
        width: mainw * .95,
        border_color: color3,
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
        controller: functions.email_controller_registeration,
        border_color: color3,
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

  Widget DisplayOwnerUserNameTextField() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<LocalFunctionProvider>(
      builder: (context, functions, child) => MyTextFormFieldTemplate(
        top: mainh * 0.02,
        height: mainh * 0.06,
        controller: functions.owner_name_controller_registeration,
        border_color: color3,
        textInputType: TextInputType.visiblePassword,
        text: MyServices().capitalizeEachWord('Owner Name'),
        textStyle: Theme.of(context)
            .textTheme
            .headlineLarge!
            .copyWith(color: color1, fontSize: mainh * 0.06 * .40),
        width: mainw * .95,
      ),
    );
  }

  Widget DisplayStoreName() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<LocalFunctionProvider>(
      builder: (context, functions, child) => MyTextFormFieldTemplate(
        top: mainh * 0.02,
        height: mainh * 0.06,
        border_color: color4,
        controller: functions.store_name_controller_registeration,
        textInputType: TextInputType.visiblePassword,
        text: MyServices().capitalizeEachWord('store name'),
        textStyle: Theme.of(context)
            .textTheme
            .headlineLarge!
            .copyWith(color: color1, fontSize: mainh * 0.06 * .40),
        width: mainw * .95,
      ),
    );
  }

  Widget DateOfBirth() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        MyServices().ShowDatePicker(
          context: context,
          mode: CupertinoDatePickerMode.date,
        );
      },
      child: Consumer<LocalFunctionProvider>(
        builder: (context, localfunction, child) => Container(
          margin: EdgeInsets.only(top: mainh * .02),
          width: mainw * .95,
          height: mainh * 0.07,
          padding: EdgeInsets.symmetric(horizontal: mainw * 0.01),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: 2,
                color: color4,
              )),
          child: AutoSizeText(
            MyServices().capitalizeEachWord(
                " date of birth :  ${DateFormat("yyyy-MM-dd").format(localfunction.dateTime)}"),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }

  Widget DisplayGender() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return
        // gender .
        GestureDetector(
      onTap: () {
        //
        MyServices().ShowGenderOptionSheet(
          context: context,
          width: mainw,
          height: mainh * .20,
        );
        //
      },
      child: Container(
        margin: EdgeInsets.only(top: mainh * 0.02),
        width: mainw * .95,
        height: mainh * 0.065,
        padding: EdgeInsets.only(left: mainw * .85 * 0.015),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: color4,
              width: 2,
            )),
        child: Consumer<LocalFunctionProvider>(
          builder: (context, functions, child) => AutoSizeText(
            MyServices().capitalizeEachWord('gender : ${functions.gender}'),
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.black,
                  fontSize: mainh * 0.065 * .335,
                ),
          ),
        ),
      ),
    );
  }

  Future RegisterButtonFunction() async {
    // get local provider .
    LocalFunctionProvider functions = context.read<LocalFunctionProvider>();

    // get firebase provider
    FirebaseProvider firebase = context.read<FirebaseProvider>();

    // check registeration values validity .
    bool valid = functions.CheckRegisterationvalues();

    // get values form controlles
    // get owner name from controllers
    String owner_name =
        functions.owner_name_controller_registeration.text.toLowerCase().trim();
    // get store name from controllers
    String store_name =
        functions.store_name_controller_registeration.text.toLowerCase().trim();
    // get Email from controllers
    String email =
        functions.email_controller_registeration.text.toLowerCase().trim();
    // get country .
    String? country = functions.countryModel != null
        ? functions.countryModel!.country_name.toLowerCase().trim()
        : null;
    // get country code
    String? country_code = functions.countryModel != null
        ? functions.countryModel!.country_code.toLowerCase().trim()
        : null;
    // get dialcode .
    String? dialcode = functions.countryModel != null
        ? functions.countryModel!.country_dialcode
        : null;
    // get number without dialcode
    String number = functions.number_controller_registeration.text.trim();
    // get passwrod from controllers
    String password = functions.password_controller_registeration.text.trim();

    // check all is valid .
    if (valid == true) {
      // show loading .
      MyServices().ShowLoading(context: context);
      // create new store .
      await firebase.RegisterStore(
        country: country!,
        country_code: country_code!,
        dialcode: dialcode!,
        email: email,
        number: number,
        owner_name: owner_name,
        password: password,
        store_name: store_name,
      ).whenComplete(
        () {
          // close loading .
          MyServices().HideSheet(context: context);

          // show notification sheet .
          MyServices().ShowNotificationSheet(
              context: context,
              type: Notification_Type.success,
              action: () {
                try {
                  // hide sheet .
                  MyServices().HideSheet(context: context);

                  // going to login page .
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: FirstPage(), type: PageTransitionType.fade),
                  );

                  // clear controllers .
                  functions.ClearControllers();
                } catch (e) {
                  print(
                      "there is an error in register function in widget after notification sheet closed: $e");
                }
              },
              message:
                  'store account has been created successFully , thank you ');
        },
      );
    }
    // field/s is/are empty .
    else {
      print("there is some fields are empty pelase check it  !");
      // show notificaion sheet .
      MyServices().ShowNotificationSheet(
          context: context,
          action: () {},
          type: Notification_Type.alert,
          message: 'some fields are empty , please fill it up and try again ');
    }
  }
}
