import 'package:IotApp/bloc/general_bloc.dart';
import 'package:IotApp/items/item_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Products extends StatefulWidget {
  Products({Key key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    GeneralBloc bloc;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) {
              bloc = GeneralBloc()..add(GetProductsEvent());
              return bloc;
            },
            child: BlocBuilder<GeneralBloc, GeneralState>(
              builder: (context, state) {
                if (state is GeneralInitial) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .85,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: bloc.getProductsList.length != null
                            ? bloc.getProductsList.length
                            : 0,
                        itemBuilder: (BuildContext context, int index) {
                          return ItemProduct(
                            index: index,
                            product: bloc.getProductsList[index],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
