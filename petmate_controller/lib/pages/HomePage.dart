import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:petmate_controller/Services/MyServices.dart';
import 'package:petmate_controller/Widgets/LoadingIndicator.dart';
import 'package:petmate_controller/Widgets/MyBackButtonTemplate.dart';
import 'package:petmate_controller/Widgets/MyButtonTemplate.dart';
import 'package:petmate_controller/Widgets/MyStoreTemplate.dart';
import 'package:petmate_controller/Widgets/TextWithEditTemplate.dart';
import 'package:petmate_controller/Widgets/edit%20store%20information%20sheets/EditEmailSheet.dart';
import 'package:petmate_controller/Widgets/edit%20store%20information%20sheets/EditOwnerNameSheet.dart';
import 'package:petmate_controller/Widgets/edit%20store%20information%20sheets/EditPhoneNumberSheet.dart';
import 'package:petmate_controller/Widgets/edit%20store%20information%20sheets/EditStoreNameSheet.dart';
import 'package:petmate_controller/main.dart';
import 'package:petmate_controller/models/StoreModel.dart';
import 'package:petmate_controller/pages/DisplayItemsPage.dart';
import 'package:petmate_controller/pages/FirstPage.dart';
import 'package:petmate_controller/pages/OrdersPage.dart';
import 'package:petmate_controller/providers/FirebaseProvider.dart';
import 'package:petmate_controller/providers/LocalFunctionProvider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        automaticallyImplyLeading: false,
        backgroundColor: color2,
        toolbarHeight: mainh * 0.065,
        title: AutoSizeText(
          MyServices().capitalizeEachWord('pet mate'),
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: color1,
                fontWeight: FontWeight.bold,
                fontSize: mainh * 0.065 * 0.40,
              ),
        ),
      ),
      body: context.watch<FirebaseProvider>().currnet_store != null
          ? Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[50],
              child: RefreshIndicator(
                onRefresh: () async {
                  // get current store id .
                  StoreModel? store =
                      context.read<FirebaseProvider>().currnet_store;
                  if (store != null) {
                    context
                        .read<FirebaseProvider>()
                        .GetStores(store_id: store.store_id)
                        .whenComplete(
                      () {
                        print("update store information has been done !");
                      },
                    );
                  }
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      //  display store image .
                      DisplayStoreImage(),

                      // display button for edit image .
                      DisplayEditImageButton(),

                      // store name , edit .
                      DisplayStoreNameWithEdit(),

                      // store owner name .
                      DisplayOwnerNameWithEdit(),

                      // email .
                      DisplayEmailWithEdit(),

                      // phone number
                      DisplayPhoneNumber(),

                      // orders button .
                      OrderButton(),

                      // display items button .
                      ItemsButton(),

                      // logout
                      LogoutButton(),

                      // space
                      SizedBox(
                        width: mainw,
                        height: mainh * 0.05,
                      )
                    ],
                  ),
                ),
              ),
            )
          :
          // show loading indicator untill functions end
          Center(
              child: LoadingIndicator(),
            ),
    );
  }

  Widget OrderButton() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<FirebaseProvider>(
        builder: (context, firebase, child) => firebase.currnet_store != null
            ? MyButtonTemplate(
                top: mainh * 0.02,
                radius: 5,
                backgroundColor: color3,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: mainh * 0.055 * .50),
                height: mainh * 0.055,
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: OrdersPage(
                            store_id: firebase.currnet_store!.store_id,
                          ),
                          type: PageTransitionType.leftToRightWithFade));
                },
                text: MyServices().capitalizeEachWord('orders'),
                width: mainw * 0.95)
            : SizedBox());
  }

  Widget ItemsButton() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<FirebaseProvider>(
        builder: (context, firebase, child) => firebase.currnet_store != null
            ? MyButtonTemplate(
                top: mainh * 0.02,
                radius: 5,
                backgroundColor: color4,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: mainh * 0.055 * .50),
                height: mainh * 0.055,
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: DisplayItemsPage(),
                          type: PageTransitionType.leftToRightWithFade));
                },
                text: MyServices().capitalizeEachWord('items'),
                width: mainw * 0.95)
            : SizedBox());
  }

  Widget DisplayStoreNameWithEdit() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<FirebaseProvider>(
        builder: (context, firebase, child) => firebase.currnet_store != null
            ? TextWithEditTemplate(
                top: mainh * 0.025,
                raduis: 5,
                backgroundcolor: Colors.white,
                icon: IconButton(
                    onPressed: () {
                      // show sheet for update .
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: EditStoreNameSheet(),
                        ),
                      ).whenComplete(
                        () {
                          // clear controllers .
                          context
                              .read<LocalFunctionProvider>()
                              .ClearControllers();
                        },
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
                text: MyServices()
                    .capitalizeEachWord(firebase.currnet_store!.store_name),
                height: mainh * 0.07,
                width: mainw * .95)
            : SizedBox());
  }

  Widget DisplayOwnerNameWithEdit() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<FirebaseProvider>(
        builder: (context, fireabse, child) => fireabse.currnet_store != null
            ? TextWithEditTemplate(
                top: mainh * 0.025,
                raduis: 5,
                backgroundcolor: Colors.white,
                icon: IconButton(
                    onPressed: () {
                      // show sheet for update .
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: EditOwnerNameSheet(),
                        ),
                      ).whenComplete(
                        () {
                          // clear controllers .
                          context
                              .read<LocalFunctionProvider>()
                              .ClearControllers();
                        },
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
                text: MyServices()
                    .capitalizeEachWord(fireabse.currnet_store!.owner_name),
                height: mainh * 0.07,
                width: mainw * .95)
            : SizedBox());
  }

  Widget DisplayPhoneNumber() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<FirebaseProvider>(
      builder: (context, firebase, child) => firebase.currnet_store != null
          ? TextWithEditTemplate(
              top: mainh * 0.025,
              raduis: 5,
              backgroundcolor: Colors.white,
              icon: IconButton(
                  onPressed: () {
                    // show sheet for update .
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: EditPhoneNumberSheet(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  )),
              text: MyServices()
                  .capitalizeEachWord(firebase.currnet_store!.phone_number),
              height: mainh * 0.07,
              width: mainw * .95)
          : SizedBox(),
    );
  }

  Widget DisplayEmailWithEdit() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<FirebaseProvider>(
        builder: (context, firebase, child) => firebase.currnet_store != null
            ? TextWithEditTemplate(
                top: mainh * 0.025,
                raduis: 5,
                backgroundcolor: Colors.white,
                icon: IconButton(
                    onPressed: () {
                      // show sheet for update .
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: EditEmailSheet(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
                text: MyServices()
                    .capitalizeEachWord(firebase.currnet_store!.email),
                height: mainh * 0.07,
                width: mainw * .95)
            : SizedBox());
  }

  Widget DisplayStoreImage() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<FirebaseProvider>(
        builder: (context, firebase, child) => firebase.currnet_store != null
            ? Container(
                width: mainw,
                height: mainh * .35,
                decoration: BoxDecoration(
                    color: color2,
                    image: DecorationImage(
                      image: firebase.currnet_store != null &&
                              firebase.currnet_store!.store_image != null
                          ? NetworkImage(firebase.currnet_store!.store_image!)
                          : AssetImage('images/no_image.jpeg'),
                      fit: BoxFit.fill,
                    )),
              )
            : SizedBox());
  }

  Widget DisplayEditImageButton() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<FirebaseProvider>(
      builder: (context, firebase, child) => Consumer<LocalFunctionProvider>(
          builder: (context, functions, child) => firebase.currnet_store != null
              ? MyButtonTemplate(
                  height: mainh * 0.055,
                  backgroundColor: color4,
                  radius: 5,
                  top: mainh * 0.015,
                  onPressed: () async {
                    // choose the image
                    XFile? my_image = await functions.ChooseImage();
                    // check
                    if (firebase.currnet_store != null && my_image != null) {
                      // show loading .
                      MyServices().ShowLoading(context: context);
                      // upload the image .
                      await firebase.UploadStoreImage(
                              image: my_image,
                              pre_image: firebase.currnet_store!.store_image)
                          .whenComplete(
                        () {
                          // close the loading
                          MyServices().HideSheet(context: context);
                        },
                      );
                    }
                  },
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Colors.white,
                        fontSize: mainh * 0.055 * .50,
                        fontWeight: FontWeight.bold,
                      ),
                  text: MyServices().capitalizeEachWord('edit image'),
                  width: mainw * .95)
              : SizedBox()),
    );
  }

  Widget LogoutButton() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<FirebaseProvider>(
        builder: (context, firebase, child) => firebase.currnet_store != null
            ? MyButtonTemplate(
                top: mainh * 0.02,
                radius: 5,
                backgroundColor: color3,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: mainh * 0.055 * .50),
                height: mainh * 0.055,
                onPressed: () {
                  context.read<LocalFunctionProvider>().UnsaveLogin();

                  //
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: FirstPage(), type: PageTransitionType.fade));

                  context.read<FirebaseProvider>().logout();
                },
                text: MyServices().capitalizeEachWord('logout'),
                width: mainw * 0.95)
            : SizedBox());
  }
}
