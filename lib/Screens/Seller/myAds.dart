import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mazadcar/Models/car.dart';
import 'package:mazadcar/Screens/Common/carCard.dart';

class MyAds extends StatefulWidget {
  const MyAds({super.key});

  @override
  State<MyAds> createState() => _MyAdsState();
}

void goToCarAdPage(BuildContext myContext, Car car) {
  Navigator.of(myContext).pushNamed('/carAdPage', arguments: {'car': car});
}

class _MyAdsState extends State<MyAds> {
  bool isLoading = false;
  Future<void> deleteImageFromFirebase(List<dynamic> toBeDeleted) async {
    if (toBeDeleted != null) {
      for (var image in toBeDeleted!) {
        Reference photoRef = FirebaseStorage.instance.refFromURL(image);

        await photoRef.delete().then((value) => print("Done"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var carInstances = FirebaseFirestore.instance
        .collection("cars")
        .where("sellerId", isEqualTo: FirebaseAuth.instance.currentUser!.uid);

    var myStream = carInstances.snapshots();
    // var myStreamSaved = savedInstances.snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: myStream,
        builder: (ctx, strSnapshot) {
          if (strSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var carList = strSnapshot.data!.docs;
          var oldAds = strSnapshot.data!.docs.where(
            (element) {
              print(Car.constructFromFirebase(
                      element.data() as Map, element.reference.id)
                  .endDate);

              print(DateTime.now());
              return Car.constructFromFirebase(
                      element.data() as Map, element.reference.id)
                  .endDate
                  .isBefore(DateTime.now());
            },
          ).toList();

          var onGoingCars = strSnapshot.data!.docs.where(
            (element) {
              return Car.constructFromFirebase(
                      element.data() as Map, element.reference.id)
                  .endDate
                  .isAfter(DateTime.now());
            },
          ).toList();

          return Column(
            // mainAxisSize: MainAxisSize.,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "Old ADs:",
                          overflow: TextOverflow.fade,
                          softWrap: true,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 159, 11, 11),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 150.0,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: oldAds.length,
                    itemBuilder: (BuildContext context, int index) {
                      Car car = Car.constructFromFirebase(
                          oldAds[index].data() as Map,
                          oldAds[index].reference.id);
                      return GestureDetector(
                        onTap: () => goToCarAdPage(context, car),
                        child: Container(
                          child: Card(
                            child: Container(
                              child: SizedBox(
                                height: 50,
                                width: 180,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      car.make +
                                          " " +
                                          car.model +
                                          " " +
                                          car.year,
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        border: Border.all(),
                                      ),
                                      child: Column(
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Final Price",
                                                softWrap: true,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "EGP " +
                                                    car
                                                        .getHighestBid()
                                                        .toString(),
                                                softWrap: true,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.arrow_right_rounded,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                border: Border.all(),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey, //New
                                      blurRadius: 5.0,
                                      offset: Offset(0, 10))
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "On Going Ads:",
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 159, 11, 11),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: onGoingCars.length,
                        shrinkWrap: true,
                        itemBuilder: (itemCtx, index) {
                          Car car = Car.constructFromFirebase(
                              onGoingCars[index].data() as Map,
                              onGoingCars[index].reference.id);
                          return Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey, //New
                                      blurRadius: 5.0,
                                      offset: Offset(0, 10))
                                ],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                color: Colors.black),
                            child: Column(
                              children: [
                                CarCard(car: car),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            '/addCarImage',
                                            arguments: {'Car': car});
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        deleteImageFromFirebase(
                                                jsonDecode(car.imageURL))
                                            .then((value) {
                                          FirebaseFirestore.instance
                                              .collection("cars")
                                              .doc(car.id)
                                              .delete();
                                        }).then((_) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          // Navigator.of(context)
                                          //     .pushReplacement(MaterialPageRoute<void>(
                                          //   builder: (BuildContext context) => MyCars(),
                                          // ));
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/', (route) => false);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        });
  }
}
