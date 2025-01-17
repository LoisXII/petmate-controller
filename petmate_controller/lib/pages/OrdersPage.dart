import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:petmate_controller/Services/MyServices.dart';
import 'package:petmate_controller/Widgets/LoadingIndicator.dart';
import 'package:petmate_controller/Widgets/MyBackButtonTemplate.dart';
import 'package:petmate_controller/Widgets/OrderTemplate.dart';
import 'package:petmate_controller/main.dart';
import 'package:petmate_controller/models/StoreModel.dart';
import 'package:petmate_controller/providers/FirebaseProvider.dart';

import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  String store_id;
  OrdersPage({super.key, required this.store_id});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    context.read<FirebaseProvider>().GetOrders(
          store_id: widget.store_id,
        );
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
          leading: MyBackButtonTemplate(),
          backgroundColor: color2,
          toolbarHeight: mainh * 0.065,
          title: AutoSizeText(
            MyServices().capitalizeEachWord('orders page'),
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: color1,
                  fontWeight: FontWeight.bold,
                  fontSize: mainh * 0.065 * 0.40,
                ),
          ),
        ),
        body: context.watch<FirebaseProvider>().orders != null &&
                context.watch<FirebaseProvider>().currnet_store != null
            ? Container(
                width: double.infinity,
                height: double.infinity,
                child: RefreshIndicator(
                  onRefresh: () async {
                    // get current store .
                    StoreModel? current_store =
                        context.read<FirebaseProvider>().currnet_store;

                    if (current_store != null) {
                      context
                          .read<FirebaseProvider>()
                          .GetOrders(store_id: current_store.store_id);
                    }
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // display orders  .
                        DisplayOrders(),

                        // space .
                        SizedBox(
                          width: mainw,
                          height: mainh * 0.05,
                        )

                        //
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: LoadingIndicator(),
              ));
  }

  Widget DisplayOrders() {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;
    return Consumer<FirebaseProvider>(
        builder: (context, firebase, child) => firebase.orders != null &&
                firebase.orders!.isNotEmpty
            ? ListView.builder(
                itemCount: firebase.orders!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => UnconstrainedBox(
                  child: OrderTemplate(
                    top: mainh * 0.02,
                    phone_number: firebase.orders![index].phone_number,
                    cart_total_price: firebase.orders![index].cart_total_price,
                    delivery_fees: firebase.orders![index].delivery_fees,
                    item_total_price: firebase.orders![index].item_total_price,
                    tax_fees: firebase.orders![index].tax_fees,
                    order_date: firebase.orders![index].order_date,
                    order_id: firebase.orders![index].order_id,
                    status: firebase.orders![index].stauts,
                    store_id: firebase.orders![index].store_id,
                    user_id: firebase.orders![index].user_id,
                    user_name: firebase.orders![index].user_name,
                    items: firebase.orders![index].items,
                  ),
                ),
              )
            : firebase.orders!.isEmpty
                ? Container(
                    width: mainw,
                    height: mainh * .10,
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      "there is no orders found !",
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                color: color1,
                                fontSize: mainh * .1 * .25,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  )
                : SizedBox());
  }
}
