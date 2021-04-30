import 'package:IotApp/models/movement.dart';
import 'package:flutter/material.dart';

/*
  Clase de ítem de movimiento
*/

class ItemMovement extends StatefulWidget {
  final Movement movement;
  final int index;
  ItemMovement({Key key, this.index, this.movement}) : super(key: key);

  @override
  _ItemMovementState createState() => _ItemMovementState();
}

class _ItemMovementState extends State<ItemMovement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(5),
        color: Colors.blue[50],
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
                  '${widget.movement.product.imagen}',
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Container(
                alignment: Alignment(0, 0),
                width: MediaQuery.of(context).size.width * 0.3,
                child: Text(
                  '${widget.movement.product.nombre}',
                  textAlign: TextAlign.center,
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Fecha movimiento"),
                    Text('${widget.movement.timestamp}'),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}