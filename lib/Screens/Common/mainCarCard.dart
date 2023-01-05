import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mazadcar/Models/car.dart';

class MainCarCard extends StatefulWidget {
  Car car;

  MainCarCard({required this.car});

  @override
  State<MainCarCard> createState() => _MainCarCardState();
}

class _MainCarCardState extends State<MainCarCard> {
  bool? isSaved;
  Future<void> checkIfSavedOrNot() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("saved")
        .doc(widget.car.id)
        .get();
    if (!mounted) return;
    setState(() {
      isSaved = ds.exists;
    });
  }

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      checkIfSavedOrNot();
    } else {
      isSaved = false;
    }

    super.initState();
  }

  void goToCarAdPage(BuildContext myContext) {
    Navigator.of(myContext)
        .pushNamed('/carAdPage', arguments: {'car': widget.car});
  }

  void addToSaved(String carID) async {
    if (carID != "") {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("saved")
          .doc(carID)
          .set({"carId": carID});
    }
  }

  @override
  Widget build(BuildContext context) {
    return isSaved == null
        ? SizedBox(
            height: 130,
            width: 50,
            child: Container(
                margin: EdgeInsets.all(10),
                color: Color.fromARGB(255, 206, 206, 206)),
          )
        : InkWell(
            onTap: () => goToCarAdPage(context),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: null,
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     isSaved!
                  //         ? IconButton(
                  //             onPressed: () {
                  //               FirebaseFirestore.instance
                  //                   .collection("users")
                  //                   .doc(FirebaseAuth.instance.currentUser!.uid)
                  //                   .collection("saved")
                  //                   .doc(widget.car.id)
                  //                   .delete();
                  //               checkIfSavedOrNot().then((value) {
                  //                 setState(() {});
                  //               });
                  //             },
                  //             icon: Icon(Icons.bookmark))
                  //         : IconButton(
                  //             onPressed: () {
                  //               addToSaved(widget.car.id);
                  //               checkIfSavedOrNot().then((value) {
                  //                 setState(() {});
                  //               });
                  //             },
                  //             icon: Icon(Icons.bookmark_outline),
                  //           ),
                  //   ],
                  // ),
                  Divider(
                    color: Colors.black,
                    height: 5,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 140,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            jsonDecode(widget.car.imageURL)[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${widget.car.make} ${widget.car.model} ${widget.car.year}'
                                        .toUpperCase(),
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                isSaved!
                                    ? IconButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .collection("saved")
                                              .doc(widget.car.id)
                                              .delete();
                                          checkIfSavedOrNot().then((value) {
                                            setState(() {});
                                          });
                                        },
                                        icon: Icon(Icons.bookmark))
                                    : IconButton(
                                        onPressed: () {
                                          addToSaved(widget.car.id);
                                          checkIfSavedOrNot().then((value) {
                                            setState(() {});
                                          });
                                        },
                                        icon: Icon(Icons.bookmark_outline),
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text.rich(
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                    TextSpan(
                                      text:
                                          'EGP ${widget.car.getHighestBid().toString()}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF006E7F)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(
                                    "assets/images/car_ad_icons/icons8-engine-30.png",
                                    height: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                                Expanded(
                                  child: Text.rich(
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      TextSpan(
                                        text: '  ${widget.car.engine}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      )),
                                ),
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(
                                    "assets/images/car_ad_icons/icons8-transmission-64.png",
                                    height: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                                Expanded(
                                  child: Text.rich(
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      TextSpan(
                                        text: '  ${widget.car.transmission}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(
                                    "assets/images/car_ad_icons/icons8-odometer-50.png",
                                    height: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                                Expanded(
                                  child: Text.rich(
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      TextSpan(
                                        text: '  ${widget.car.mileage} Km',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      )),
                                ),
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset(
                                    "assets/images/car_ad_icons/icons8-year-64.png",
                                    height: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                                // Expanded(
                                //   child: Container(
                                //     margin: const EdgeInsets.only(left: 16),
                                //     decoration: BoxDecoration(
                                //         color: Color(0xFFA10035),
                                //         borderRadius: const BorderRadius.all(
                                //             Radius.circular(5))),
                                //     padding: const EdgeInsets.all(3),
                                //     child: Text(
                                //       '2019',
                                //       style: TextStyle(
                                //           color: Color(0xFFFEC260),
                                //           fontSize: 10,
                                //           fontWeight: FontWeight.w500),
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                  child: Text.rich(
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      TextSpan(
                                        text: '  ${widget.car.year}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(right: 5, top: 5),
                                    child: Text(
                                      'Time left: ${widget.car.getCountDown().toString()}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w800,
                                        // backgroundColor: Color(0xFFFEC260),
                                        color: Color(0xFFA10035),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.black,
                    height: 5,
                    thickness: 1,
                  ),
                ],
              ),
            ),
          );
  }
}
