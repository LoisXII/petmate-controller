import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:petmate_controller/pages/FirstPage.dart';
import 'package:petmate_controller/providers/FirebaseProvider.dart';
import 'package:petmate_controller/providers/LocalFunctionProvider.dart';
import 'package:provider/provider.dart';

//  general color .
Color color1 = HexColor("#1c3a44");
Color color2 = HexColor("#d5d5d5");
Color color3 = HexColor("#85bc9c");
Color color4 = HexColor("#51cdd7");

void main() async {
  // load the widget first .
  WidgetsFlutterBinding.ensureInitialized();

  // init the firebase .
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      // local funcion provider .
      ChangeNotifierProvider<LocalFunctionProvider>(
        create: (context) => LocalFunctionProvider(),
      ),

      // firebase provider .
      ChangeNotifierProvider<FirebaseProvider>(
        create: (context) => FirebaseProvider(),
      )
    ],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: TextTheme(
          // this text for general text
          headlineLarge: GoogleFonts.mukta(
            color: color1,
            fontSize: 20,
          ),
        )),
        home: FirstPage()),
  ));
}
