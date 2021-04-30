import 'package:IotApp/bloc/general_bloc.dart';
import 'package:IotApp/items/item_movement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Movements extends StatefulWidget {
  Movements({Key key}) : super(key: key);

  @override
  _MovementsState createState() => _MovementsState();
}

class _MovementsState extends State<Movements> {
  @override
  Widget build(BuildContext context) {
    GeneralBloc bloc;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) {
              bloc = GeneralBloc()..add(GetMovementsEvent());
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
                        itemCount: bloc.getMovementsList != null
                            ? bloc.getMovementsList.length
                            : 0,
                        itemBuilder: (BuildContext context, int index) {
                          return ItemMovement(
                            index: index,
                            movement: bloc.getMovementsList[index],
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