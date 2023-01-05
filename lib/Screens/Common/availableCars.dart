import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mazadcar/Providers/filter.dart';
import 'package:mazadcar/Screens/Common/carCard.dart';
import 'package:provider/provider.dart';
import '../../Models/car.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../Auth/Utils.dart';

class AvailableCars extends StatefulWidget {
  const AvailableCars({super.key});

  @override
  State<AvailableCars> createState() => _AvailableCarsState();
}

class _AvailableCarsState extends State<AvailableCars> {
  @override
  void initState() {
    var fbm = FirebaseMessaging.instance;
    fbm.requestPermission(); // only shows on ios
    fbm.subscribeToTopic("classChat");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Utils.showBlackSnackbar(message.notification?.title ?? "");
      print(message.data.toString());
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

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
