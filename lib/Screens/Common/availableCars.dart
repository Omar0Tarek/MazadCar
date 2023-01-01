import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mazadcar/Providers/filter.dart';

import 'package:mazadcar/Screens/Common/carCard.dart';
import 'package:provider/provider.dart';

import '../../Models/car.dart';

class AvailableCars extends StatefulWidget {
  const AvailableCars({super.key});

  @override
  State<AvailableCars> createState() => _AvailableCarsState();
}

class _AvailableCarsState extends State<AvailableCars> {
  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);

    var carInstances = FirebaseFirestore.instance.collection("cars");
    var myStream = carInstances.snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: myStream,
      builder: (ctx, strSnapshot) {
        if (strSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var carDocs = strSnapshot.data!.docs;
        var carList = carDocs.map(
            (e) => Car.constructFromFirebase(e.data() as Map, e.reference.id));
        var filteredCars;
        var filter;
        if (filterProvider.filter.isNotEmpty) {
          filter = filterProvider.filter;
          filteredCars = carList.where(
              (car) => (filter['make'] != null && filter['make'] == car.make));
        } else {
          filteredCars = carList;
        }
        return ListView.builder(
          itemBuilder: (itemCtx, index) {
            Car car = filteredCars.elementAt(index);
            return CarCard(car: car);
          },
          itemCount: filteredCars.length,
        );
      },
    );
  }
}
