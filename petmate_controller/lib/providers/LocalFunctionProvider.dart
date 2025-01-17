import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:petmate_controller/Services/MyServices.dart';
import 'package:petmate_controller/models/CountryModel.dart';
import 'package:petmate_controller/pages/HomePage.dart';
import 'package:petmate_controller/providers/FirebaseProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalFunctionProvider with ChangeNotifier {
  // checked saved login .
  bool? checked;

  // ####################################################
  // controllers login
  TextEditingController email_controller_login = TextEditingController();
  TextEditingController password_controller_login = TextEditingController();
  // ####################################################

  // ####################################################
  // controllers for item .
  TextEditingController item_name_controller = TextEditingController();
  TextEditingController item_price_controller = TextEditingController();

  // ####################################################

  // date picker .
  DateTime dateTime = DateTime.now();

  // saved email
  String? saved_email;
  // saved password
  String? saved_password;

  // gender picker .
  String gender = 'male';

  // image choosen .
  XFile? image;

  // list of all countries
  List<CountryModel>? Countries;

  // country choosen .
  CountryModel? countryModel;

  // ####################################################
  // controllers
  TextEditingController owner_name_controller_registeration =
      TextEditingController();
  TextEditingController store_name_controller_registeration =
      TextEditingController();
  TextEditingController email_controller_registeration =
      TextEditingController();
  TextEditingController number_controller_registeration =
      TextEditingController();
  TextEditingController password_controller_registeration =
      TextEditingController();
  // ####################################################

  // ####################################################
  // controllers update store informatio n
  TextEditingController store_name_controller_upadte = TextEditingController();
  TextEditingController owner_name_controller_update = TextEditingController();
  TextEditingController email_controller_update = TextEditingController();
  TextEditingController phone_number_controller_update =
      TextEditingController();

  // ####################################################

  // Get Date Time From CupertinoDatePicker .
  DateTime? GetDateTime(DateTime _datetime) {
    dateTime = _datetime;
    notifyListeners();
  }

  // get the gender choosen by user .
  int GetGender(int index) {
    // index 0 => male
    // index 1 => female
    if (index == 0) {
      gender = "male";
    } else {
      gender = "female";
    }
    notifyListeners();
    return index;
  }

  // Get Image .
  Future<XFile?> ChooseImage() async {
    try {
      // image instance .
      XFile? _image =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (_image == null) {
        print("no image choosen !");
      } else {
        print("image choosen successFully ");
      }

      // get new image .
      image = _image;
      notifyListeners();

      return _image;
    } catch (e) {
      //
      print("there is an error in choose image function : $e");
    }
  }

  // check email validate .
  bool CheckRegisterationvalues() {
    // Get Values from Controllers.

    // get owner name from controllers
    String owner_name =
        owner_name_controller_registeration.text.toLowerCase().trim();
    // get store name from controllers
    String store_name =
        store_name_controller_registeration.text.toLowerCase().trim();
    // get Email from controllers
    String email = email_controller_registeration.text.toLowerCase().trim();
    // get country .
    String? country = countryModel != null
        ? countryModel!.country_name.toLowerCase().trim()
        : null;
    // get country code
    String? country_code = countryModel != null
        ? countryModel!.country_code.toLowerCase().trim()
        : null;
    // get dialcode .
    String? dialcode =
        countryModel != null ? countryModel!.country_dialcode : null;
    // get number without dialcode
    String number = number_controller_registeration.text.trim();
    // get passwrod from controllers
    String password = password_controller_registeration.text.trim();

    // check controller values validate .
    // check email validate .
    bool isEmailValid = email.toLowerCase().trim().contains('@') == true &&
            email.toLowerCase().trim().contains('.com') == true
        ? true
        : false;

    // check password length .
    bool isPasswordvalid = password.length < 8 ? false : true;

    // check country model is not empty .
    bool isCountryvalid = country == null ? false : true;

    // other fields .
    bool isOhterFieldsValid =
        owner_name.isNotEmpty == true && store_name.isNotEmpty == true
            ? true
            : false;

    // check all .
    bool isAllvalid = isEmailValid == true &&
            isPasswordvalid == true &&
            isCountryvalid == true
        ? true
        : false;

    //

    if (isAllvalid == true && isOhterFieldsValid == true) {
      return true;
    } else {
      return false;
    }
  }

  // get Countries From Json File
  Future<void> LoadCountries() async {
    try {
      print("Get Countries Function Has Been Started!");

      // Get json file as json string
      String jsonFile = await rootBundle.loadString('files/countries.json');

      // Decode the json file
      List<dynamic> listOfCountries = jsonDecode(jsonFile);

      // Receive port
      ReceivePort receivePort = ReceivePort();

      // Run another thread
      Isolate isolate = await Isolate.spawn(
          ReadJsonFile, [receivePort.sendPort, listOfCountries]);

      // Get countries
      List<CountryModel> finalCountries =
          await receivePort.first as List<CountryModel>;

      //
      Countries = finalCountries;
      notifyListeners();

      // Close the receive port
      receivePort.close();
      print("The recive port is closed ");

      // Kill the isolate
      isolate.kill();
      print("The new isolate  is closed ");

      print("The countries received are: ${finalCountries.length}");

      print("Get Countries Function Has Been Stopped!");
    } catch (e) {
      print('There is an error in get countries function: $e');
    }
  }

// Read file from json
  static Future<void> ReadJsonFile(List args) async {
    try {
      // send port .
      SendPort sendPort = args[0];

      // list of all countries .
      List<dynamic> listOfCountries = args[1];

      // Parse the countries
      List<CountryModel> countries = listOfCountries
          .map(
            (e) => CountryModel.FromJson(e),
          )
          .toList();

      // Send the countries
      sendPort.send(countries);
    } catch (e) {
      print("There is an error in read json file function: $e");
    }
  }

  // get The Country Choosen.
  void GetCountry(int index) {
    if (Countries != null) {
      countryModel = Countries![index];
      notifyListeners();
    }
  }

  // clear controllers .
  void ClearControllers() {
    // controllers for registeration
    owner_name_controller_registeration.clear();
    store_name_controller_registeration.clear();
    email_controller_registeration.clear();
    number_controller_registeration.clear();
    password_controller_registeration.clear();
    //controllers for login .
    email_controller_login.clear();
    password_controller_login.clear();
    //controllers for update .
    store_name_controller_upadte.clear();
    owner_name_controller_update.clear();
    email_controller_update.clear();
    phone_number_controller_update.clear();
    // add new item
    item_name_controller.clear();
    item_price_controller.clear();
    image = null;
    countryModel = null;
    print("clear controllers has been done !");
    notifyListeners();
  }

  // save login .
  Future SaveLogin({required String email, required String password}) async {
    // get instance .
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // save the login
    await preferences.setString('email', email.trim());
    await preferences.setString('password', password.trim());
    print("the login data has been saved successully !");
  }

  // forgett login .
  Future UnsaveLogin() async {
    // get instance .
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // save the login
    await preferences.remove('email');
    await preferences.remove('password');
    print("the login data has been deleted successully !");
  }

  // forgett login .
  Future<bool> CheckLoginData({required BuildContext context}) async {
    // get instance .
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    // get the login data
    Object? _email = await preferences.get('email');
    Object? _password = await preferences.get('password');

    if (_email != null && _password != null) {
      print("the saved login is exists !");
      saved_email = _email.toString();
      saved_password = _password.toString();
      checked = true;
      notifyListeners();
      context
          .read<FirebaseProvider>()
          .LoginFunction(
              email: _email.toString(), password: _password.toString())
          .whenComplete(
        () {
          //
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: HomePage(), type: PageTransitionType.leftToRight));
          //
        },
      );
      return true;
    } else {
      print("the saved login is not exists !");
      checked = false;
      notifyListeners();
      return false;
    }
  }
}
