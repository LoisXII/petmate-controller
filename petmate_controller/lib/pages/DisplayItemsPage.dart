import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:petmate_controller/Services/MyServices.dart';
import 'package:petmate_controller/Widgets/ItemTemplate.dart';
import 'package:petmate_controller/Widgets/LoadingIndicator.dart';
import 'package:petmate_controller/Widgets/MyBackButtonTemplate.dart';
import 'package:petmate_controller/Widgets/MyButtonTemplate.dart';
import 'package:petmate_controller/main.dart';
import 'package:petmate_controller/pages/AddNewItemPage.dart';
import 'package:petmate_controller/providers/FirebaseProvider.dart';
import 'package:provider/provider.dart';

class DisplayItemsPage extends StatefulWidget {
  @override
  State<DisplayItemsPage> createState() => _DisplayItemsPageState();
}

class _DisplayItemsPageState extends State<DisplayItemsPage> {
  @override
  void initState() {
    context.read<FirebaseProvider>().GetItems();
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
          automaticallyImplyLeading: false,
          backgroundColor: color2,
          toolbarHeight: mainh * 0.065,
          title: AutoSizeText(
            MyServices().capitalizeEachWord('items'),
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: color1,
                  fontWeight: FontWeight.bold,
                  fontSize: mainh * 0.065 * 0.40,
                ),
          ),
        ),
        body: context.watch<FirebaseProvider>().items != null
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey[50],
                child: RefreshIndicator(
                  onRefresh: () async {
                    await context.read<FirebaseProvider>().GetItems();
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // display add new item button .
                        DisplayAddItemButton(),

                        // display items for store  .
                        DisplayItems(),

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
            : Center(
                child: LoadingIndicator(),
              ));
  }

  Widget DisplayItems() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<FirebaseProvider>(
        builder: (context, firebase, child) => firebase.items != null &&
                firebase.items!.isNotEmpty
            ? ListView.builder(
                itemCount: firebase.items!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => UnconstrainedBox(
                  child: ItemTemplate(
                      delete: () async {
                        // show loading .
                        MyServices().ShowLoading(context: context);

                        //
                        String imageUrl = firebase.items![index].item_image;
                        String item_id = firebase.items![index].item_id;
                        //
                        // run function .
                        await firebase.DeleteItem(
                          item_id: item_id,
                          image_url: imageUrl,
                        );

                        // get items .
                        await firebase.GetItems();

                        // hide.
                        MyServices().HideSheet(context: context);
                      },
                      top: mainh * 0.02,
                      index: index,
                      height: mainh * 0.12,
                      width: mainw * .95,
                      item_id: firebase.items![index].item_id,
                      item_image: firebase.items![index].item_image,
                      item_name: firebase.items![index].item_name,
                      item_price: firebase.items![index].item_price),
                ),
              )
            : firebase.items == null
                ? Container(
                    width: mainw,
                    height: mainh * .2,
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      MyServices().capitalizeEachWord('loading'),
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                color: color1,
                                fontSize: mainh * .2 * .35,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  )
                : Container(
                    width: mainw,
                    height: mainh * .10,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      MyServices()
                          .capitalizeEachWord('there is no item found !'),
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                color: color1,
                                fontSize: mainh * .10 * .20,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ));
  }

  Widget DisplayAddItemButton() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return MyButtonTemplate(
        height: mainh * 0.045,
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: AddNewItemPage(), type: PageTransitionType.fade));
        },
        top: mainh * 0.015,
        radius: 2.5,
        backgroundColor: color4,
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: mainh * .045 * .60,
            ),
        text: MyServices().capitalizeEachWord('add item'),
        width: mainw * .95);
  }
}
