import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mazadcar/Screens/Common/carCard.dart';

import '../../Models/car.dart';

class AvailableCars extends StatefulWidget {
  const AvailableCars({super.key});

  @override
  State<AvailableCars> createState() => _AvailableCarsState();
}

class _AvailableCarsState extends State<AvailableCars> {
  @override
  Widget build(BuildContext context) {
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
        var carList = strSnapshot.data!.docs;
        return ListView.builder(
          itemBuilder: (itemCtx, index) {
            Car car = Car.constructFromFirebase(
                carList[index].data() as Map, carList[index].reference.id);
            return CarCard(car: car);
          },
          itemCount: carList.length,
        );
      },
    );
  }
}
