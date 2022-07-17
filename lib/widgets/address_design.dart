import 'package:breejstores_users_app/Models/address.dart';
import 'package:breejstores_users_app/assisantMethods/address_change.dart';
import 'package:breejstores_users_app/constants/constants.dart';
import 'package:breejstores_users_app/mainScreens/placed_order_Screen.dart';
import 'package:breejstores_users_app/maps/maps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressDesign extends StatefulWidget {
  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;

  const AddressDesign({Key? key,
    this.model,
    this.currentIndex,
    this.value,
    this.addressID,
    this.totalAmount,
    this.sellerUID})
      : super(key: key);

  @override
  State<AddressDesign> createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Container(
        margin: const EdgeInsets.all(kDefaultPadding / 2),
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                spreadRadius: 1, blurRadius: 1, color: Colors.grey.shade300)
          ],
          color: Colors.white,
        ),
        child: Column(
          children: [
            //ADDRESS INFO
            Row(
              children: [
                Radio(
                  value: widget.value!,
                  groupValue: widget.currentIndex!,
                  activeColor: Colors.cyan,
                  onChanged: (val) {
                    //PROVIDER
                    Provider.of<AddressChanger>(context, listen: false)
                        .displayResult(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.8,
                      padding: const EdgeInsets.all(kDefaultPadding / 2),
                      child: Table(
                        children: [
                          TableRow(children: [
                            const Text(
                              "Name: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(widget.model!.name.toString())
                          ]),
                          TableRow(children: [
                            const Text(
                              "Phone: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(widget.model!.phoneNumber.toString())
                          ]),
                          TableRow(children: [
                            const Text(
                              "State: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(widget.model!.state.toString())
                          ]),
                          TableRow(children: [
                            const Text(
                              "Address: ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(widget.model!.fullAddress.toString())
                          ]),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //CHECK ON MAPS BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.cyan),
                  onPressed: () {
                    MapsUtils.openMapWithPosition(
                        widget.model!.lat!, widget.model!.long!);
                  },
                  child: const Text(
                    "Check on maps",
                  ),
                ),
                //PROCEED BUTTON
                widget.value ==
                    Provider
                        .of<AddressChanger>(context, listen: false)
                        .count
                    ? ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => PlacedOrderScreen(
                          addressID: widget.addressID,
                          totalAmount: widget.totalAmount,
                          sellerUID: widget.sellerUID,
                        )));
                  },
                  child: const Text("Proceed"),
                )
                    : const SizedBox.shrink()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
