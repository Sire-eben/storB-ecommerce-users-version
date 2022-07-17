import 'package:breejstores_users_app/Models/items.dart';
import 'package:flutter/material.dart';

class CartItemDesign extends StatefulWidget {
  final Items? model;
  BuildContext? context;
  final int? quanNumber;

  // ignore: use_key_in_widget_constructors
  CartItemDesign({this.model, this.quanNumber, this.context});

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan,
      child: Container(
        margin: const EdgeInsets.all(6),
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
              width: 125,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.model!.thumbnailUrl!.toString(),
                  )
                )
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.model!.itemTitle!,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2,),
                Text(
                  "Qty: x" + widget.quanNumber.toString(),
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "₦" + widget.model!.price.toString(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
