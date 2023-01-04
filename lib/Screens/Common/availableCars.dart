import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    var carInstances = FirebaseFirestore.instance.collection("cars").where(
        "sellerId",
        isNotEqualTo: FirebaseAuth.instance.currentUser!.uid);

    print(FirebaseAuth.instance.currentUser!.uid);
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
        Iterable<Car> carList = carDocs.map(
            (e) => Car.constructFromFirebase(e.data() as Map, e.reference.id));
        Iterable<Car> filteredCars;
        var filter;
        if (filterProvider.filter.isNotEmpty) {
          filter = filterProvider.filter;
          filteredCars = carList;

          if (filter['make'] != null && filter['make'].toString() != 'All') {
            filteredCars = filteredCars
                .where((car) => (filter['make'] == car.make.toLowerCase()));
          }
          if (filter['location'] != null &&
              filter['location'].toString() != 'All') {
            filteredCars = filteredCars.where(
                (car) => (filter['location'] == car.location.toLowerCase()));
          }
          if (filter['maxMileage'] != null) {
            filteredCars = filteredCars
                .where((car) => (filter['maxMileage'] >= car.mileage));
          }
          if (filter['transmission'] != null &&
              filter['transmission'].toString() != 'All') {
            filteredCars = filteredCars.where((car) =>
                (filter['transmission'].toString().toLowerCase() ==
                    car.transmission.toLowerCase()));
          }
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
