import 'package:breejstores_users_app/Models/product.dart';
import 'package:breejstores_users_app/mainScreens/items_screen.dart';
import 'package:flutter/material.dart';

class ProductsDesignWidget extends StatefulWidget {
  Products? model;
  BuildContext? context;

  ProductsDesignWidget({Key? key, this.model, this.context}) : super(key: key);

  @override
  State<ProductsDesignWidget> createState() => _ProductsDesignWidgetState();
}

class _ProductsDesignWidgetState extends State<ProductsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ItemsScreen(
          model: widget.model
        )));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 10,
              blurRadius: 10,
            )
          ]
        ),
        height: 265,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          children: [
            Image.network(
              widget.model!.thumbnailUrl!,
              height: 210,
              fit: BoxFit.cover,
            ),
            Text(
              widget.model!.productTitle!,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              widget.model!.productDescription!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,),
            ),
          ],
        ),
      ),
    );
  }
}
