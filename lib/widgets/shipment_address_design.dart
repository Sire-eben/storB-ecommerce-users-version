import 'package:breejstores_users_app/Models/address.dart';
import 'package:breejstores_users_app/constants/constants.dart';
import 'package:breejstores_users_app/mainScreens/home_screen.dart';
import 'package:flutter/material.dart';

class ShipmentAddressDesign extends StatelessWidget {
  final Address? model;

  const ShipmentAddressDesign({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        children: [
          const Text(
            "Shipping Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
            width: MediaQuery.of(context).size.width,
            child: Table(
              children: [
                TableRow(children: [
                  const Text(
                    "Name:",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    model!.name!,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
                TableRow(children: [
                  const Text(
                    "Phone:",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    model!.phoneNumber!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Address: " + model!.fullAddress!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.justify,
          ),
          Container(
            margin: const EdgeInsets.all(kDefaultPadding),
            height: 50,
            width: MediaQuery.of(context).size.width - 70,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.cyan),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ))
              ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (c) => const HomeScreen()),
                      (route) => false);
                },
                icon: const Icon(Icons.home),
                label: const Text("Continue Shopping")),
          )
        ],
      ),
    );
  }
}
