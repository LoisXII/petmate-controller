import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:petmate_controller/Services/MyServices.dart';
import 'package:petmate_controller/main.dart';

class TextWithIconTemplate extends StatelessWidget {
  double width;
  double height;
  double? top;
  String text;
  TextStyle? style;
  IconData? icon;
  double? raduis;
  BorderRadiusGeometry? borderRadius;
  bool? shadow;

  TextWithIconTemplate({
    super.key,
    this.shadow,
    required this.height,
    required this.width,
    this.borderRadius,
    this.raduis,
    this.icon,
    this.top,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: top ?? 0),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: shadow == null || shadow == true
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(1.5, 1.5),
                  blurRadius: 2.5,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(-1.5, -1.5),
                  blurRadius: 2.5,
                )
              ]
            : null,
        borderRadius: borderRadius ?? BorderRadius.circular(raduis ?? 0),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          children: [
            // icon .
            Container(
              width: constraints.maxWidth * .15,
              height: constraints.maxHeight,
              color: Colors.transparent,
              child: Transform.scale(
                scaleX: constraints.maxWidth * 0.0025,
                scaleY: constraints.maxHeight * 0.015,
                child: Icon(
                  icon,
                  color: color3,
                ),
              ),
            ),

            // divder .
            VerticalDivider(
              color: Colors.black.withOpacity(0.1),
              endIndent: constraints.maxHeight * 0.20,
              indent: constraints.maxHeight * 0.20,
              width: constraints.maxWidth * 0.05,
            ),

            // text .
            Container(
              width: constraints.maxWidth * .80,
              height: constraints.maxHeight,
              padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * .75 * 0.03),
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                MyServices().capitalizeEachWord(text),
                style: style ??
                    Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: color1,
                          fontSize: constraints.maxHeight * 0.35,
                          fontWeight: FontWeight.bold,
                        ),
              ),
            )

            //
          ],
        ),
      ),
    );
  }
}
