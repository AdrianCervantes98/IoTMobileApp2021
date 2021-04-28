import 'package:IotApp/views/movements.dart';
import 'package:IotApp/views/products.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Función de cambio de vistas
  void _onItemTapped(int index) {
    setState(() {
      _currIndex = index;
    });
  }
  //Lista de vistas
  final _currView = [
    Products(),
    Movements()
  ];

  //Índice de la lista de vistas
  int _currIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(child: _currView[_currIndex]),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.store_outlined,
                ),
                label: 'Productos'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.arrow_forward_outlined,
                ),
                label: 'Movimientos'),
          ],
          iconSize: MediaQuery.of(context).size.width / 10,
          selectedItemColor: Colors.blue[700],
          currentIndex: _currIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}