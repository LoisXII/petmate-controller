import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petmate_controller/Services/MyServices.dart';
import 'package:petmate_controller/Widgets/ItemTemplate.dart';
import 'package:petmate_controller/Widgets/MyBackButtonTemplate.dart';
import 'package:petmate_controller/Widgets/MyButtonTemplate.dart';
import 'package:petmate_controller/Widgets/MyTextFormFieldTemplate.dart';
import 'package:petmate_controller/main.dart';
import 'package:petmate_controller/providers/FirebaseProvider.dart';
import 'package:petmate_controller/providers/LocalFunctionProvider.dart';
import 'package:provider/provider.dart';

class AddNewItemPage extends StatefulWidget {
  @override
  State<AddNewItemPage> createState() => _AddNewItemPageState();
}

class _AddNewItemPageState extends State<AddNewItemPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          centerTitle: true,
          leading: const MyBackButtonTemplate(),
          backgroundColor: color2,
          toolbarHeight: mainh * 0.065,
          title: AutoSizeText(
            MyServices().capitalizeEachWord('add new item '),
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
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // display item image .
                DisplayItemImage(),

                // upload image .
                DisplayUploadImageButton(),

                // item name textfield .
                ItemNameTextField(),

                // item price textfield
                ItemPriceTextField(),

                // button for publish .
                DisplayPublishButton(),

                // space
                SizedBox(
                  width: mainw,
                  height: mainh * 0.05,
                )
              ],
            ),
          ),
        ));
  }

  Widget DisplayPublishButton() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<FirebaseProvider>(
      builder: (context, firebase, child) => Consumer<LocalFunctionProvider>(
        builder: (context, functions, child) => MyButtonTemplate(
            top: mainh * 0.02,
            height: mainh * 0.06,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Colors.white,
                  fontSize: mainh * 0.06 * .45,
                  fontWeight: FontWeight.bold,
                ),
            backgroundColor: color3,
            radius: 5,
            onPressed: () async {
              // get the item name from controller .
              String item_name =
                  functions.item_name_controller.text.toLowerCase().trim();
              // get item price from controller .
              String item_price =
                  functions.item_price_controller.text.toLowerCase().trim();

              // image .
              XFile? image = functions.image;

              // check none if those are empty or null .
              if (item_name.isNotEmpty &&
                  item_price.isNotEmpty &&
                  image != null) {
                //
                // show  loading .
                MyServices().ShowLoading(context: context);

                // create new item .
                await firebase.AddNewItem(
                    item_name: item_name,
                    item_price: item_price,
                    item_image: image);

                //clear controllers .
                functions.ClearControllers();

                // hide the loading .
                MyServices().HideSheet(context: context);

                // show notificaion .
                MyServices().ShowNotificationSheet(
                  context: context,
                  type: Notification_Type.success,
                  message: MyServices().capitalizeEachWord(
                      'item has been uploaded successfully '),
                  action: () {
                    // going to back page .
                    MyServices().HideSheet(context: context);
                  },
                );
              }
            },
            text: MyServices().capitalizeEachWord('publish item'),
            width: mainw * .95),
      ),
    );
  }

  Widget DisplayUploadImageButton() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return MyButtonTemplate(
        top: mainh * 0.02,
        height: mainh * 0.06,
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Colors.white,
              fontSize: mainh * 0.06 * .45,
              fontWeight: FontWeight.bold,
            ),
        backgroundColor: color3,
        radius: 5,
        onPressed: () {
          context.read<LocalFunctionProvider>().ChooseImage();
        },
        text: MyServices().capitalizeEachWord('upload image'),
        width: mainw * .95);
  }

  Widget DisplayItemImage() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<LocalFunctionProvider>(
      builder: (context, functions, child) => Container(
        width: mainw,
        height: mainh * .35,
        decoration: BoxDecoration(
            color: color2,
            image: DecorationImage(
                image: functions.image != null
                    ? FileImage(File(functions.image!.path))
                    : AssetImage("images/no_image.jpeg"),
                fit: BoxFit.fill)),
      ),
    );
  }

  Widget ItemNameTextField() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<LocalFunctionProvider>(
      builder: (context, functions, child) => MyTextFormFieldTemplate(
        height: mainh * 0.055,
        top: mainh * 0.015,
        controller: functions.item_name_controller,
        textStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: color1,
              fontSize: mainh * 0.055 * .40,
              fontWeight: FontWeight.bold,
            ),
        text: 'item name',
        width: mainw * .95,
      ),
    );
  }

  Widget ItemPriceTextField() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<LocalFunctionProvider>(
      builder: (context, functions, child) => MyTextFormFieldTemplate(
        height: mainh * 0.055,
        top: mainh * 0.015,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
        textInputType: TextInputType.number,
        controller: functions.item_price_controller,
        textStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: color1,
              fontSize: mainh * 0.055 * .40,
              fontWeight: FontWeight.bold,
            ),
        text: 'item price',
        width: mainw * .95,
      ),
    );
  }
}
