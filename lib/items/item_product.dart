import 'package:IotApp/models/product.dart';
import 'package:flutter/material.dart';

/*
  Clase de ítem de producto
*/
class ItemProduct extends StatefulWidget {
  final Product product;
  final int index;

  ItemProduct({Key key, this.index, this.product}) : super(key: key);

  @override
  _ItemProductState createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(5),
        color: Colors.lime[100],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              alignment: Alignment(0, 0),
              width: MediaQuery.of(context).size.width * 0.25,
              child: ClipOval(
                child: Image.network(
                  '${widget.product.imagen}',
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Container(
                alignment: Alignment(0, 0),
                width: MediaQuery.of(context).size.width * 0.3,
                child: Text(
                  '${widget.product.nombre}',
                  textAlign: TextAlign.center,
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Cantidad"),
                    Text('${widget.product.cantidad}'),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
