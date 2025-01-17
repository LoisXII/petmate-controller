import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petmate_controller/models/ItemModel.dart';
import 'package:petmate_controller/models/OrderModel.dart';
import 'package:petmate_controller/models/StoreModel.dart';
import 'package:petmate_controller/models/UserLoginModel.dart';

// orderstatus enum
enum OrderStatusEnum { hold, accept, cancel }

class FirebaseProvider with ChangeNotifier {
  // list of all stores .
  List<StoreModel>? stores;
  // single store .
  StoreModel? store;

  // currnet store .
  StoreModel? currnet_store;

  // orders .
  List<OrderModel>? orders;

  // list of stoer's items
  List<ItemModel>? items;

  // login data .
  UserLoginModel? store_login;

  // delete item .
  Future DeleteItem(
      {required String item_id, required String image_url}) async {
    try {
      // delete item from database .
      await FirebaseFirestore.instance
          .collection('items')
          .doc(item_id)
          .delete();

      // delete image from storage .
      await FirebaseStorage.instance.refFromURL(image_url).delete();

      print('the item has been deleted from databaes , storage successfully !');
    } catch (e) {
      print("there is an error in delete item function : $e");
    }
  }

  // add new item .
  Future AddNewItem({
    required String item_name,
    required String item_price,
    required XFile item_image,
  }) async {
    // upload image to storage .
    // get ref .
    Reference imageRef =
        await FirebaseStorage.instance.ref('items/${item_image.name}');

    // upload image .
    await imageRef.putFile(File(item_image.path));
    // get the url .
    String image_url = await imageRef.getDownloadURL();

    // check if the item has image url.
    if (image_url.isNotEmpty && currnet_store != null) {
      // upload image to firestore .
      await FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          // set new
          transaction
              .set(FirebaseFirestore.instance.collection('items').doc(), {
            'item_name': item_name.toLowerCase().trim(),
            'item_price': item_price.trim(),
            'store_id': currnet_store!.store_id.trim(),
            'item_image': image_url.trim(),
          });
        },
      );
    }
  }

  // get items .
  Future GetItems() async {
    try {
      if (currnet_store != null) {
        items = await FirebaseFirestore.instance
            .collection('items')
            .where('store_id', isEqualTo: currnet_store!.store_id.trim())
            .get()
            .then(
              (value) => value.docs
                  .map(
                    (e) => ItemModel.FromJson(item_id: e.id, data: e.data()),
                  )
                  .toList(),
            );
      }
      print("items found :${items != null ? items!.length : 'null'}");

      //
      notifyListeners();
    } catch (e) {
      print("there is an error in get items functions : $e");
    }
  }

  // login function .
  Future<UserLoginModel> LoginFunction(
      {required String email, required String password}) async {
    try {
      // check if the user(store) exists .
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('stores')
          .where('email', isEqualTo: email)
          .get();

      // check the user exists or not (using email ).
      // case 1 user exists .value
      if (data.docs.isNotEmpty == true) {
        // get the user (store) information .
        StoreModel _store =
            StoreModel.FromJson(data.docs.first.id, data.docs.first.data());

        print("the user (${_store.email}) found !");
        // check the password
        // password match .
        if (password.trim() == _store.password.trim()) {
          //

          store_login = UserLoginModel(
            email: email,
            user_id: _store.store_id,
            password: _store.password,
            exists: true,
            user_login_status_enum:
                UserLoginStatusEnum.user_found_password_match,
          );
          currnet_store = _store;
          notifyListeners();
          return store_login!;
        }

        // password not match .
        else {
          //
          store_login = UserLoginModel(
            email: email,
            exists: false,
            user_login_status_enum: UserLoginStatusEnum.password_notmatch,
          );
          notifyListeners();
          return store_login!;
        }
      }

      // case 2 user not exists
      else {
        // email not exists .
        store_login = UserLoginModel(
          email: email,
          exists: false,
          user_login_status_enum: UserLoginStatusEnum.user_notfound,
        );
        notifyListeners();

        return store_login!;
      }
    } catch (e) {
      print("there is an error in login function : $e");
      store_login = UserLoginModel(
          email: email,
          exists: false,
          user_login_status_enum: UserLoginStatusEnum.error);

      notifyListeners();
      return store_login!;
    }
  }

  // get stores / store .
  Future GetStores({required String store_id}) async {
    // get specific store .
    currnet_store = await FirebaseFirestore.instance
        .collection('stores')
        .doc(store_id)
        .get()
        .then(
          (value) => StoreModel.FromJson(value.id, value.data()!),
        );
    //
    notifyListeners();
  }

  // creaet New Store ,
  Future RegisterStore({
    required String owner_name,
    required String store_name,
    required String email,
    required String password,
    required String number,
    required String country,
    required String country_code,
    required String dialcode,
  }) async {
    try {
      // doc ref .
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('stores').doc();

      // run transaction on create new documnet .
      await FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          // create new store .
          await transaction.set(documentReference, {
            "store_name": store_name.toLowerCase().trim(),
            "country": country.toLowerCase().trim(),
            "dialcode": dialcode.toLowerCase().trim(),
            "country_code": country_code.toLowerCase().trim(),
            "number": number,
            "phone_number": "$dialcode$number",
            "owner_name": owner_name.toLowerCase().trim(),
            "password": password.trim(),
            "email": email.toLowerCase().trim(),
            "store_image": null,
          });
        },
      );
    } catch (e) {
      print("there is an error in register new store function : $e");
    }
  }

  // update store name .
  Future UpdateStoreName({required String store_name}) async {
    print("the new store name : $store_name");
    try {
      // check if the user loged in or not .
      if (currnet_store != null) {
        // check if the store name has value .
        if (store_name.isNotEmpty) {
          // run transcation .
          await FirebaseFirestore.instance.runTransaction(
            (transaction) async {
              await transaction.update(
                  FirebaseFirestore.instance
                      .collection('stores')
                      .doc(currnet_store!.store_id),
                  {
                    "store_name": store_name.toLowerCase().trim(),
                  });
            },
          ).whenComplete(
            () {
              print(
                  "updating the store name to $store_name has been done successfully !");
            },
          );
        }
        // new store name is empty !
        else {
          print("the new store name is empty $store_name");
        }

        //
      } else {
        print("user not logged in !");
      }
    } catch (e) {
      print("there is an error in update store name : $e");
    }
  }

  // update store name .
  Future UpdateOwnerName({required String owner_name}) async {
    print("the new Owner name : $owner_name");
    try {
      // check if the user loged in or not .
      if (currnet_store != null) {
        // check if the store name has value .
        if (owner_name.isNotEmpty) {
          // run transcation .
          await FirebaseFirestore.instance.runTransaction(
            (transaction) async {
              await transaction.update(
                  FirebaseFirestore.instance
                      .collection('stores')
                      .doc(currnet_store!.store_id),
                  {
                    "owner_name": owner_name.toLowerCase().trim(),
                  });
            },
          ).whenComplete(
            () {
              print(
                  "updating the owner name to $owner_name has been done successfully !");
            },
          );
        }
        // new store name is empty !
        else {
          print("the new owner name is empty $owner_name");
        }

        //
      } else {
        print("user not logged in !");
      }
    } catch (e) {
      print("there is an error in update owner name : $e");
    }
  }

  // update the email .
  Future UpdateTheEmail({required String email}) async {
    print("the new email  : $email");
    try {
      // check if the user loged in or not .
      if (currnet_store != null) {
        // check if the store name has value .
        if (email.isNotEmpty &&
            email.toLowerCase().trim().contains('.com') == true &&
            email.toLowerCase().trim().contains('@') == true) {
          // run transcation .
          await FirebaseFirestore.instance.runTransaction(
            (transaction) async {
              await transaction.update(
                  FirebaseFirestore.instance
                      .collection('stores')
                      .doc(currnet_store!.store_id),
                  {
                    "email": email.toLowerCase().trim(),
                  });
            },
          ).whenComplete(
            () {
              print(
                  "updating the email to $email has been done successfully !");
            },
          );
        }
        // new store name is empty !
        else {
          print("the new email is empty or check the email formate  $email");
        }

        //
      } else {
        print("user not logged in !");
      }
    } catch (e) {
      print("there is an error in update email  : $e");
    }
  }

  // update the phonenumber .
  Future UpdatePhoneNumber({
    required String number,
    required String dialcode,
  }) async {
    print("the new phone_number  : $number");
    print("the new dialcode  : $dialcode");

    try {
      // check if the user loged in or not .
      if (currnet_store != null) {
        // check if the store name has value .
        if (number.isNotEmpty && dialcode.isNotEmpty) {
          // run transcation .
          await FirebaseFirestore.instance.runTransaction(
            (transaction) async {
              await transaction.update(
                  FirebaseFirestore.instance
                      .collection('stores')
                      .doc(currnet_store!.store_id),
                  {
                    "phone_number": "$dialcode$number",
                    'dialcode': dialcode,
                    'number': number,
                  });
            },
          ).whenComplete(
            () {
              print(
                  "updating the PhoneNumber to $dialcode$number has been done successfully !");
            },
          );
        }
        // new store name is empty !
        else {
          print("the new phone is empty   $dialcode$number");
        }

        //
      } else {
        print("user not logged in !");
      }
    } catch (e) {
      print("there is an error in update PhoneNumber  : $e");
    }
  }

  // upload store image .
  Future UploadStoreImage(
      {required XFile image, required String? pre_image}) async {
    try {
      // check the user login or not .
      if (store_login != null &&
          store_login!.exists == true &&
          store_login!.user_id != null) {
        //check if there is pre image to delete .
        //  previous image exists
        if (pre_image != null && pre_image.isNotEmpty) {
          // delete previous image from firestore .
          await FirebaseFirestore.instance
              .collection('stores')
              .doc(store_login!.user_id)
              .update({
            "store_image": null,
          }).whenComplete(
            () {
              print(
                  "deleteing previous from firestore image has done successfully !");
            },
          );

          // deleteing previous image from storage .
          await FirebaseStorage.instance
              .refFromURL(pre_image)
              .delete()
              .whenComplete(
            () {
              print(
                  "deleteing previous from storage image has done successfully !");
            },
          );
        }

        // upload the image .
        await FirebaseStorage.instance
            .ref('stores/${image.name}')
            .putFile(File(image.path))
            .then(
          (p0) async {
            print("the upload new image to storage has been done ");
            // get the documet ref .
            DocumentReference documentReference = FirebaseFirestore.instance
                .collection('stores')
                .doc(store_login!.user_id);
            // upload the image to firestore
            await FirebaseFirestore.instance.runTransaction(
              (transaction) async {
                String image_ref = await p0.ref.getDownloadURL();
                // update the image in  store .
                await transaction.update(documentReference, {
                  'store_image': image_ref,
                });
              },
            ).whenComplete(
              () {
                print(
                    "upload the image to firestore has been done successFully !");
              },
            );
          },
        );
      }

      //
    } catch (e) {
      print("there is an error in upload store image : $e");
    }
  }

  // get Orders .
  Future GetOrders({required String store_id}) async {
    try {
      //
      orders = await FirebaseFirestore.instance
          .collection('orders')
          .where('store_id', isEqualTo: store_id)
          .get()
          .then(
            (value) => value.docs
                .map(
                  (e) => OrderModel.FromJson(order_id: e.id, data: e.data()),
                )
                .toList(),
          );

      notifyListeners();
      print("the order found :${orders != null ? orders!.length : "null"} ");
      //
    } catch (e) {
      print("there is an error in Get orders function : $e");
    }
  }

  // change order Status .
  Future ChangeOrderStatus(
      {required String order_id, required OrderStatusEnum new_status}) async {
    //
    try {
      //
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order_id)
          .update({
        "status": new_status == OrderStatusEnum.accept ? 'accept' : 'cancel'
      });
      //
    } catch (e) {
      print("there is an error in change order status functio :$e");
    }
    //
  }

  void logout() {
    currnet_store = null;
    notifyListeners();
  }
}
