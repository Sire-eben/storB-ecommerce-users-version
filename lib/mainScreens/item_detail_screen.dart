import 'package:breejstores_users_app/Models/items.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:provider/provider.dart';

import '../assisantMethods/assistant_methods.dart';
import '../assisantMethods/cart_item_counter.dart';
import 'cart_screen.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;

  const ItemDetailsScreen({Key? key, this.model}) : super(key: key);

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.amber,
                ],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(1, 0),
                stops: [0, 1],
                tileMode: TileMode.clamp),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "breejStores",
          style: TextStyle(
            fontFamily: "Signatra",
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                  onPressed: () {
                    //sEND USER TO CART PAGE
                    Navigator.push(context, MaterialPageRoute(builder: (c) => CartScreen(
                      sellerUID: widget.model!.sellerUID
                    )));
                  },
                  icon: const Icon(Icons.shopping_cart)),
              Positioned(
                child: Stack(
                  children: [
                    const Icon(
                      Icons.brightness_1,
                      size: 20,
                      color: Colors.red,
                    ),
                    Positioned(
                      top: 3,
                      right: 4,
                      child: Center(
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, c) {
                            return Text(
                              counter.count.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: (){
                  showDialog(context: context, builder: (c){
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: NetworkImage(widget.model!.thumbnailUrl.toString())
                        )
                      ),
                    );
                  });
                },
                child: Image.network(widget.model!.thumbnailUrl.toString())),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                child: NumberInputPrefabbed.leafyButtons(
                  controller: counterTextEditingController,
                  incDecBgColor: Colors.black,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  incIcon: EvaIcons.plus,
                  incIconColor: Colors.white,
                  incIconSize: 30,
                  decIcon: EvaIcons.minus,
                  decIconColor: Colors.white,
                  decIconSize: 30,
                  numberFieldDecoration: const InputDecoration(
                    border: InputBorder.none
                  ),
                  min: 1,
                  max: 9,
                  initialValue: 1,
                  buttonArrangement: ButtonArrangement.incRightDecLeft,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                widget.model!.itemTitle.toString(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all( 18.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only( left: 18.0),
              child: Text(
                "₦" + widget.model!.price.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.amber)),
                    onPressed: () {
                      int itemCounter = int.parse(counterTextEditingController.text);

                      //CHECK IF ITEM EXIST IN CART
                      List<String> separateItemIdsList = separateItemIDs();
                      separateItemIdsList.contains(widget.model!.itemID)
                      ? Fluttertoast.showToast(msg: "Item already added to cart")
                      //ADD ITEM TO CART
                      : addItemToCart(widget.model!.itemID, context, itemCounter);
                    },
                    child: const Text(
                      "Add to cart",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
