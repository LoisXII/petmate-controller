import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petmate_controller/Services/MyServices.dart';
import 'package:petmate_controller/main.dart';
import 'package:petmate_controller/providers/LocalFunctionProvider.dart';
import 'package:provider/provider.dart';

class MyPhoneNumberTextFiledTemplate extends StatefulWidget {
  double width;
  double height;
  String text;
  TextStyle? textStyle;
  Color? border_color;
  TextInputType? textInputType;
  Color? cursorColor;
  TextEditingController? controller;
  double? top;
  List<TextInputFormatter>? inputFormatters;

  MyPhoneNumberTextFiledTemplate({
    super.key,
    this.controller,
    this.cursorColor,
    required this.height,
    this.inputFormatters,
    this.top,
    required this.text,
    this.textInputType,
    this.textStyle,
    required this.width,
    this.border_color,
  });

  @override
  State<MyPhoneNumberTextFiledTemplate> createState() =>
      _MyPhoneNumberTextFiledTemplateState();
}

class _MyPhoneNumberTextFiledTemplateState
    extends State<MyPhoneNumberTextFiledTemplate> {
  @override
  void initState() {
    context.read<LocalFunctionProvider>().LoadCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.top ?? 0),
      width: widget.width,
      height: widget.height,
      child: CupertinoTextField(
        controller: widget.controller,
        prefix: Consumer<LocalFunctionProvider>(
            builder: (context, functions, child) => functions.Countries != null
                ? GestureDetector(
                    onTap: () {
                      //
                      MyServices().ShowCountrySheet(context: context);
                      //
                    },
                    child: Container(
                      padding:
                          EdgeInsets.only(left: widget.width * .10 * 0.015),
                      width: widget.width * .20,
                      height: widget.height * .75,
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: AutoSizeText(
                        functions.countryModel != null
                            ? functions.countryModel!.country_dialcode
                            : "---",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: color1,
                                fontWeight: FontWeight.bold,
                                fontSize: widget.height * .75 * .35),
                      ),
                    ),
                  )
                : const SizedBox()),
        inputFormatters: widget.inputFormatters,
        placeholder: MyServices().capitalizeEachWord(widget.text),
        placeholderStyle: widget.textStyle ??
            Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.black,
                ),
        onTapOutside: (event) {
          //  keyboared hide .
          MyServices().HideKeyboard(context: context);
        },
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: widget.border_color ?? color3,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(1.5, 1.5),
                blurRadius: 5,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(-1.5, -1.5),
                blurRadius: 5,
              ),
            ]),
        cursorColor: widget.cursorColor,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: widget.textInputType,
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
