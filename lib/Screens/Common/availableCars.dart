import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mazadcar/Providers/carProvider.dart';
import 'package:mazadcar/Screens/Common/carCard.dart';

import '../../Data/carList.dart';
import '../../Models/car.dart';

class AvailableCars extends StatefulWidget {
  final List<Car> carList;
  const AvailableCars({super.key, required this.carList});

  @override
  State<AvailableCars> createState() =>
      _AvailableCarsState(unusedCarList: carList);
}

class _AvailableCarsState extends State<AvailableCars> {
  List<Car> unusedCarList;
  _AvailableCarsState({required this.unusedCarList});
  // var carProvider;
  // var carList;

  @override
  void initState() {
    // var carProvider = Provider.of<CarProvider>(context, listen: false);
    // carProvider.fetchCarsFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // carProvider = Provider.of<CarProvider>(context, listen: true);
    // carList = carProvider.getAllCars;
    print("Car List");
    print(carList);
    return GridView.count(
      crossAxisCount: 1,
      mainAxisSpacing: 30,
      children: carList.map((c) {
        return CarCard(car: c);
      }).toList(),
    );
  }
}
