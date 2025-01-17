import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:petmate_controller/Services/MyServices.dart';
import 'package:petmate_controller/Widgets/MyButtonTemplate.dart';
import 'package:petmate_controller/main.dart';

class ItemTemplate extends StatelessWidget {
  double width;
  double height;
  double? top;
  int index;
  void Function() delete;
  String item_name;
  String item_price;
  String item_image;
  String item_id;
  TextStyle? style_name;
  TextStyle? style_price;
  TextStyle? style_delete;

  ItemTemplate({
    super.key,
    this.style_name,
    this.style_delete,
    this.style_price,
    required this.delete,
    required this.height,
    this.top,
    required this.index,
    required this.width,
    required this.item_id,
    required this.item_image,
    required this.item_name,
    required this.item_price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: top ?? 0),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(1, 1),
            blurRadius: 5,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(-1, -1),
            blurRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // item details .
            Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight * .65,
              color: Colors.transparent,
              child: LayoutBuilder(
                builder: (context, constraints) => Row(
                  children: [
                    // item image .
                    Container(
                      width: constraints.maxWidth * .20,
                      height: constraints.maxHeight,
                      color: Colors.transparent,
                      child: LayoutBuilder(
                        builder: (context, constraints) => UnconstrainedBox(
                          child: Container(
                            width: constraints.maxWidth * .90,
                            height: constraints.maxHeight * .90,
                            decoration: BoxDecoration(
                                color: color2,
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                    image: NetworkImage(item_image),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ),
                    ),

                    // divider .
                    VerticalDivider(
                      color: Colors.black.withOpacity(0.10),
                      indent: constraints.maxHeight * .2,
                      endIndent: constraints.maxHeight * .2,
                      thickness: 0.5,
                      width: constraints.maxWidth * 0.05,
                    ),

                    // item name
                    Container(
                      width: constraints.maxWidth * .6,
                      height: constraints.maxHeight,
                      color: Colors.transparent,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          left: constraints.maxWidth * .6 * 0.015),
                      child: SingleChildScrollView(
                        child: AutoSizeText(
                          MyServices().capitalizeEachWord(item_name),
                          style: style_name ??
                              Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                    color: color1,
                                    fontSize: constraints.maxHeight * 0.25,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),

                    // price .
                    Container(
                      width: constraints.maxWidth * .15,
                      height: constraints.maxHeight,
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: AutoSizeText(
                        "$item_price JD",
                        style: style_price ??
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  color: color1,
                                  fontSize: constraints.maxHeight * 0.25,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    )

                    //
                  ],
                ),
              ),
            ),
            //space .
            Divider(
              color: Colors.black.withOpacity(0.10),
              endIndent: constraints.maxWidth * 0.05,
              indent: constraints.maxWidth * 0.05,
              height: constraints.maxHeight * 0.085,
              thickness: 0.5,
            ),

            // item controllers button .
            MyButtonTemplate(
                height: constraints.maxHeight * .23,
                onPressed: () {
                  delete();
                },
                radius: 2.5,
                backgroundColor: index % 2 == 0 ? color4 : color3,
                style: style_delete ??
                    Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: constraints.maxHeight * .23 * .60,
                        ),
                text: MyServices().capitalizeEachWord('delete'),
                width: constraints.maxWidth * .98),

            //space .
            SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight * 0.035,
            )
          ],
        ),
      ),
    );
  }
}
