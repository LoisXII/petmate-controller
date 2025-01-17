import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:petmate_controller/main.dart';

class TextWithEditTemplate extends StatelessWidget {
  double width;
  double height;
  double? top;
  String text;
  TextStyle? style;
  Widget icon;
  Color? backgroundcolor;
  double? raduis;
  TextWithEditTemplate({
    super.key,
    this.top,
    this.raduis,
    this.style,
    this.backgroundcolor,
    required this.icon,
    required this.text,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: top ?? 0),
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: backgroundcolor ?? Colors.red,
          borderRadius: BorderRadius.circular(raduis ?? 0),
          boxShadow: [
            BoxShadow(
              color: color1.withOpacity(0.06),
              offset: Offset(1, 1),
              blurRadius: 5,
            ),
            BoxShadow(
              color: color1.withOpacity(0.06),
              offset: Offset(-1, -1),
              blurRadius: 5,
            ),
          ]),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          children: [
            // edit button .
            Container(
              width: constraints.maxWidth * .18,
              height: constraints.maxHeight,
              color: Colors.transparent,
              alignment: Alignment.center,
              child: LayoutBuilder(
                builder: (context, constraints) => Container(
                  width: constraints.maxWidth * .80,
                  height: constraints.maxHeight * .80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color4,
                    borderRadius: BorderRadius.circular(raduis ?? 0),
                  ),
                  child: Transform.scale(
                    scaleX: (constraints.maxWidth * .80) * .03,
                    scaleY: (constraints.maxHeight * .80) * .03,
                    child: icon,
                  ),
                ),
              ),
            ),

            //divider .
            VerticalDivider(
              color: Colors.black.withOpacity(0.1),
              endIndent: constraints.maxHeight * 0.1,
              thickness: 0.5,
              indent: constraints.maxHeight * 0.1,
              width: constraints.maxWidth * 0.05,
            ),

            // text.
            Container(
              width: constraints.maxWidth * .75,
              height: constraints.maxHeight,
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              padding:
                  EdgeInsets.only(left: constraints.maxWidth * .75 * 0.015),
              child: AutoSizeText(
                text,
                style: style ??
                    Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontSize: constraints.maxHeight * 0.30,
                          color: color1,
                          fontWeight: FontWeight.bold,
                        ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
