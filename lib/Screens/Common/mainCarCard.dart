import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mazadcar/Models/car.dart';

class MainCarCard extends StatefulWidget {
  Car car;
  bool saved;

  MainCarCard({required this.car, required this.saved});

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
        : Column(
            children: [
              InkWell(
                onTap: () => goToCarAdPage(context),
                child: SizedBox(
                  child: Container(
                    height: 180,
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey, //New
                            blurRadius: 5.0,
                            offset: Offset(0, 10))
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      border: Border.all(),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 130,
                              width: 100,
                              child: Image.network(
                                jsonDecode(widget.car.imageURL)[0],
                                fit: BoxFit.fill,
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
                                          widget.car.make +
                                              " " +
                                              widget.car.model +
                                              " " +
                                              widget.car.year,
                                          overflow: TextOverflow.fade,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      FirebaseAuth.instance.currentUser != null
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                isSaved!
                                                    ? IconButton(
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "users")
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                              .collection(
                                                                  "saved")
                                                              .doc(
                                                                  widget.car.id)
                                                              .delete();

                                                          checkIfSavedOrNot()
                                                              .then((value) {});
                                                        },
                                                        icon: Icon(
                                                            Icons.bookmark))
                                                    : IconButton(
                                                        onPressed: () {
                                                          addToSaved(
                                                              widget.car.id);

                                                          checkIfSavedOrNot()
                                                              .then((value) {});
                                                        },
                                                        icon: Icon(Icons
                                                            .bookmark_outline))
                                              ],
                                            )
                                          : Text("")
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Highest Bid",
                                              overflow: TextOverflow.fade,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text.rich(
                                              softWrap: false,
                                              overflow: TextOverflow.fade,
                                              TextSpan(
                                                text:
                                                    'EGP ${widget.car.getHighestBid().toString()}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    // fontWeight: FontWeight.w700,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Text(
                                            widget.car
                                                .getCountDown()
                                                .toString(),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              // backgroundColor: Color(0xFFFEC260),
                                              color: Color(0xFFA10035),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
