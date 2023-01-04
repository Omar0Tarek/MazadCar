import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mazadcar/Models/car.dart';
import 'package:mazadcar/Screens/Common/carCard.dart';

class BidsPlaced extends StatefulWidget {
  const BidsPlaced({super.key});

  @override
  State<BidsPlaced> createState() => _BidsPlacedState();
}

class _BidsPlacedState extends State<BidsPlaced> {
  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
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
        Iterable<Car> carList = carDocs.map(
            (e) => Car.constructFromFirebase(e.data() as Map, e.reference.id));

        Iterable<Car> filteredCars =
            carList.where((car) => (car.userHasBid(currentUserId)));

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
