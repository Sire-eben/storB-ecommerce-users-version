import 'package:breejstores_users_app/Global/global.dart';
import 'package:breejstores_users_app/assisantMethods/assistant_methods.dart';
import 'package:breejstores_users_app/mainScreens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PlacedOrderScreen extends StatefulWidget {
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;

  const PlacedOrderScreen({
    Key? key,
    this.addressID,
    this.totalAmount,
    this.sellerUID,
  }) : super(key: key);

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();

  addOrderDetails() {
    writeOrderDetailsForUser({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productID": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on delivery",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    });

    writeOrderDetailsForSeller({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productID": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": "Cash on delivery",
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    }).whenComplete(() {
      clearCartNow(context);
      setState(() {
        orderId = "";
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => HomeScreen()));

        Fluttertoast.showToast(msg: "Order has been placed successfully!");
      });
    });
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  Future writeOrderDetailsForSeller(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/delivery.jpg"),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () {
                addOrderDetails();
              },
              child: const Text("Place order"),
            )
          ],
        ),
      ),
    );
  }
}
