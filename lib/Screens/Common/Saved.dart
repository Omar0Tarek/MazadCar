import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:mazadcar/Models/car.dart';
import 'package:mazadcar/Models/userModel.dart';

import 'package:mazadcar/Screens/Common/availableCars.dart';
import 'package:mazadcar/Screens/Common/carCard.dart';
import 'package:mazadcar/Screens/Common/mainCarCard.dart';
import 'package:provider/provider.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  static Future<Car?> getCarModel(String carAdID) async {
    Car? car;

    DocumentSnapshot docsnapshotCar =
        await FirebaseFirestore.instance.collection("cars").doc(carAdID).get();

    if (docsnapshotCar.data() != null) {
      var carData = docsnapshotCar.data();

      car = Car.constructFromFirebase(
          carData as Map, docsnapshotCar.reference.id);
    }

    return car;
  }

  Widget build(BuildContext context) {
    var savedInstances = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("saved");
    var myStream = savedInstances.snapshots();

    return Container(
      child: StreamBuilder(
        stream: myStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              );
            } else {
              QuerySnapshot savedSnapshot = snapshot.data as QuerySnapshot;
              var savedList = snapshot.data!.docs;
              // print(chatList);
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  return FutureBuilder(
                      future: getCarModel(savedList[index].data()["carId"]),
                      builder: (context, userdata) {
                        if (userdata.connectionState == ConnectionState.done) {
                          if (userdata.data != null) {
                            Car carAD = userdata.data as Car;

                            return MainCarCard(
                              car: carAD,
                              saved: true,
                            );
                          } else {
                            return Text("User data is null");
                          }
                        } else {
                          return Text("");
                        }
                      });
                },
                itemCount: savedSnapshot.docs.length,
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          } else {
            return Center(child: Text("Error: Check Internet Connection"));
          }
        },
      ),
    );
  }
}
