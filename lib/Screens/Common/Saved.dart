import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mazadcar/Data/carList.dart';
import 'package:mazadcar/Providers/savedProvider.dart';
import 'package:mazadcar/Screens/Common/availableCars.dart';
import 'package:mazadcar/Screens/Common/carCard.dart';
import 'package:provider/provider.dart';

class Saved extends StatelessWidget {
  const Saved({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return Text("Saved");
  // }

  Widget build(BuildContext context) {
    final provider = Provider.of<SavedProvider>(context);
    final carsID = provider.carID;
//     final routeArgs =
//         ModalRoute.of(context)!.settings.arguments as Map<String, Category>;

//     // final extractedCategory = routeArgs['Category'];

    final carsInCategory = carList.where((element) {
      return carsID.contains(element.id);
    }).toList();

    return Scaffold(
        // appBar: AppBar(title: Text('Favorites')),
        body: ListView.builder(
            itemCount: carsInCategory.length,
            itemBuilder: ((ctx, index) {
              return CarCard(car: carsInCategory[index]);
            })));
  }
}
