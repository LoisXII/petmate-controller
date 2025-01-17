import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:petmate_controller/Services/MyServices.dart';
import 'package:petmate_controller/Widgets/MyButtonTemplate.dart';
import 'package:petmate_controller/Widgets/MyTextFormFieldTemplate.dart';
import 'package:petmate_controller/main.dart';
import 'package:petmate_controller/providers/FirebaseProvider.dart';
import 'package:petmate_controller/providers/LocalFunctionProvider.dart';
import 'package:provider/provider.dart';

class EditOwnerNameSheet extends StatelessWidget {
  const EditOwnerNameSheet({super.key});

  @override
  Widget build(BuildContext context) {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Container(
      width: mainw,
      height: mainh * .3,
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            // lable .
            Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight * .20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: AutoSizeText(
                MyServices().capitalizeEachWord('update owner name'),
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: color1,
                      fontSize: constraints.maxHeight * 0.2 * .35,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),

            // textformfield for new name .
            Consumer<LocalFunctionProvider>(
              builder: (context, functions, child) => MyTextFormFieldTemplate(
                height: constraints.maxHeight * .18,
                border_color: color4,
                controller: functions.owner_name_controller_update,
                text: MyServices().capitalizeEachWord('new owner name'),
                textStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: color1,
                      fontSize: constraints.maxHeight * 0.15 * .35,
                      fontWeight: FontWeight.bold,
                    ),
                width: constraints.maxWidth * .95,
              ),
            ),

            // update button .
            Consumer<FirebaseProvider>(
              builder: (context, firebase, child) =>
                  Consumer<LocalFunctionProvider>(
                builder: (context, functions, child) => MyButtonTemplate(
                    radius: 5,
                    top: constraints.maxHeight * 0.05,
                    height: constraints.maxHeight * 0.15,
                    backgroundColor: color3,
                    onPressed: () async {
                      if (functions
                          .owner_name_controller_update.text.isNotEmpty) {
                        // show loading .
                        MyServices().ShowLoading(context: context);

                        // update .
                        await firebase.UpdateOwnerName(
                                owner_name: functions
                                    .owner_name_controller_update.text
                                    .toLowerCase()
                                    .trim())
                            .whenComplete(
                          () {
                            // close the loading .
                            MyServices().HideSheet(context: context);

                            // close the sheet of editing .
                            MyServices().HideSheet(context: context);

                            // clear controllers .
                            functions.ClearControllers();

                            // show notificaion.
                            MyServices().ShowNotificationSheet(
                              context: context,
                              type: Notification_Type.success,
                              message: MyServices().capitalizeEachWord(
                                  'update the owner name has been done successfully !'),
                              action: () {},
                            );
                          },
                        );
                      } else {
                        print("the new owner name textfield is empty ! ");
                      }
                    },
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: constraints.maxHeight * 0.15 * .45,
                        ),
                    text: MyServices().capitalizeEachWord('update'),
                    width: constraints.maxWidth * .85),
              ),
            ),

            // space .
            SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight * .15,
            )
          ],
        ),
      ),
    );
  }
}
