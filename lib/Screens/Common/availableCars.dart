import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mazadcar/Providers/filter.dart';

import 'package:mazadcar/Screens/Common/mainCarCard.dart';
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
    void removeFilter() {
      filterProvider.applyFilter(new Map());
    }

    var carInstances = FirebaseAuth.instance.currentUser != null
        ? FirebaseFirestore.instance.collection("cars").where("sellerId",
            isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        : FirebaseFirestore.instance.collection("cars");

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
        Iterable<Car> filteredCars = carList;
        var filter;
        if (filterProvider.filter.isNotEmpty) {
          filter = filterProvider.filter;

          if (filter['make'] != null && filter['make'].toString() != 'All') {
            filteredCars = filteredCars
                .where((car) => (filter['make'] == car.make.toLowerCase()));
          }

          if (filter['maxMileage'] != null) {
            filteredCars = filteredCars
                .where((car) => (filter['maxMileage'] >= car.mileage));
          }
          if (filter['maxPrice'] != null) {
            filteredCars = filteredCars
                .where((car) => (filter['maxPrice'] >= car.getHighestBid()));
          }
          if (filter['transmission'] != null &&
              filter['transmission'].toString() != 'All') {
            filteredCars = filteredCars.where((car) =>
                (filter['transmission'].toString().toLowerCase() ==
                    car.engine.toLowerCase()));
          }
        } else {
          filteredCars = carList;
        }
        filteredCars = filteredCars.where((car) {
          return !car.getCountDown().contains('0 H: 0 M: 0 S');
        });
        return Column(
          children: [
            filterProvider.filter.isNotEmpty
                ? Container(
                    height: 30,
                    width: 160,
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF006E7F))),
                      child: Row(
                        children: [Text('Remove Filter'), Icon(Icons.close)],
                      ),
                      onPressed: () {
                        removeFilter();
                      },
                    ))
                : Text(''),
            Expanded(
                child: filteredCars.isNotEmpty
                    ? ListView.builder(
                        itemBuilder: (itemCtx, index) {
                          Car car = filteredCars.elementAt(index);
                          // var snap = FirebaseFirestore.instance
                          //     .collection('users')
                          //     .doc(FirebaseAuth.instance.currentUser!.uid)
                          //     .collection("saved");
                          // snap.doc()

                          return MainCarCard(
                            car: car,
                          );
                        },
                        itemCount: filteredCars.length,
                      )
                    : Container(
                        margin: EdgeInsets.all(130),
                        child: Text(
                          "No results found",
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 159, 11, 11),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ))
          ],
        );
      },
    );
  }
}
