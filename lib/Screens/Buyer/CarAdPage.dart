import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mazadcar/Models/car.dart';
import 'package:mazadcar/Models/userModel.dart';

class CarAdPage extends StatefulWidget {
  const CarAdPage({super.key});

  @override
  State<CarAdPage> createState() => _CarAdPageState();
}

class _CarAdPageState extends State<CarAdPage> {
  final bidValue = TextEditingController();
  bool _makeBid = false;
  var errorText;
  Color errorColor = Colors.red;
  var placedBid = false;

  Timer? timer;
  String deadline = "";

  bool loaded = false;

  void showToast() {
    setState(() {
      _makeBid = !_makeBid;
      setState(() {
        errorText = "";
      });
    });
  }

  static Future<UserModel?> getUserModelbyId(String uid) async {
    UserModel? chatUser;

    DocumentSnapshot docsnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docsnapshot.data() != null) {
      var user = docsnapshot.data();

      chatUser = UserModel.constructFromFirebase(
          user as Map, docsnapshot.reference.id);
    }
    return chatUser;
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, Car>;
    Car car = routeArgs['car']!;

    void initTimer() {
      if (timer != null && timer!.isActive) return;

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          deadline = car.getCountDown().toString();
        });
      });
    }

    addBid() {
      if (bidValue.text.isEmpty) {
        setState(() {
          errorText = "You must enter a valid bid price";
          errorColor = Colors.red;
        });
        return;
      }
      int bidPrice = int.parse(bidValue.text);
      if (bidPrice <= car.getHighestBid()) {
        setState(() {
          errorText = "New bid should be higher than the current highest bid";
          errorColor = Colors.red;
        });
        return;
      }

      String biddingUserID = FirebaseAuth.instance.currentUser!.uid;
      car.addBid(biddingUserID, bidPrice);
      FirebaseFirestore.instance
          .collection("cars")
          .doc(car.id)
          .update({
            'bids': car.bids,
          })
          .catchError((err) {})
          .then((_) {
            setState(() {
              _makeBid = !_makeBid;
              errorText = "New bid placed successfully";
              bidValue.text = "";
              errorColor = Colors.green;
            });
          });
    }

    cancelBid() {
      String biddingUserID = FirebaseAuth.instance.currentUser!.uid;
      if (car.userHasBid(biddingUserID)) {
        car.cancelUserBid(biddingUserID);
        FirebaseFirestore.instance
            .collection("cars")
            .doc(car.id)
            .update({
              'bids': car.bids,
            })
            .catchError((err) {})
            .then((_) {
              setState(() {
                errorText = "Bid cancelled successfully";
                errorColor = Colors.green;
              });
            });
      } else {
        setState(() {
          errorText = "You didn't bid on the car previously";
          errorColor = Colors.red;
        });
      }
    }

    void chatWithSeller() {
      String biddingUserID = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance.collection("chats").add({
        'sellerID': car.sellerId,
        'buyerID': biddingUserID,
        'adID': car.id,
        'adName': car.name,
      }).then((documentSnapshot) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }).catchError((err) {
        return showDialog(
            context: context,
            builder: ((ctx) {
              return AlertDialog(
                title: Text("An error occurred"),
                content: Text(
                  err.toString(),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("Okay"))
                ],
              );
            }));
      });
    }

    getSectionName(String sectionName) {
      return Container(
        margin: const EdgeInsets.all(8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            sectionName,
            style: const TextStyle(
              color: Color(0xFF006E7F),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    getNameRow(String name) {
      return Container(
        margin: const EdgeInsets.all(8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    // TO DO: Show Icons
    Widget getDetailsRow(String rowName, String rowValue) {
      initTimer();
      return Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    rowName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    rowValue,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      );
    }

    getDetailsRowDivider() {
      return const Divider(
        color: Colors.black,
        height: 3,
        thickness: 0.5,
      );
    }

    getSellerSection(UserModel currentUser) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 10,
          ),
          Container(
            height: 120,
            width: 90,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                currentUser.profilepic,
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
                        currentUser.name,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                          text: 'Phone: ${currentUser.phone}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
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
                          text: 'Email: ${currentUser.email}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
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
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 16),
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: Size.fromHeight(30),
                        ),
                        onPressed: chatWithSeller,
                        child: Text("Chat"),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      );
    }

    if (FirebaseAuth.instance.currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          title: Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.only(left: 10, bottom: 20, top: 10),
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),
        ),
        body: SizedBox(
          height: 200,
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            child: Center(
                child: Text(
              "Sign in to Start",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 30),
            )),
          ),
        ),
      );
    }

    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder(
      future: getUserModelbyId(car.sellerId),
      builder: (context, userdata) {
        if (userdata.connectionState == ConnectionState.waiting && !loaded) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        loaded = true;

        var currentUser = userdata.data as UserModel;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        // height: 300.0,
                        aspectRatio: 4 / 3,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        scrollDirection: Axis.horizontal,
                      ),
                      items:
                          List<String>.from(jsonDecode(car.imageURL)).map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              // margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(color: Colors.amber),
                              child: Image.network(
                                i,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  getNameRow((car.make + " " + car.model + " " + car.year)
                      .toUpperCase()),
                  getSectionName("Bidding"),
                  getDetailsRow("Highest Bid", car.getHighestBid().toString()),
                  car.bids.containsKey(currentUserId)
                      ? getDetailsRow('Your Current Bid:',
                          car.bids[currentUserId].toString())
                      : Container(),

                  getDetailsRow("Bid End", deadline),
                  /////////////////////////show when press button////////////////////////
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 18),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        // minimumSize: Size.fromHeight(50),
                      ),
                      onPressed: showToast,
                      child: Text(
                        "Make Bid",
                        style: TextStyle(color: Colors.blue),
                      )),

                  ///
                  Visibility(
                    visible: _makeBid,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(5),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      InputDecoration(labelText: "Bid Price"),
                                  controller: bidValue,
                                ),
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              ),
                              onPressed: () => addBid(),
                              child: Text('Bid'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
///////////////////////////////////////till here////////////////////////////
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 18),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)),
                      // minimumSize: Size.fromHeight(50),
                    ),
                    // style: ButtonStyle(
                    //   foregroundColor:
                    //       MaterialStateProperty.all<Color>(Colors.red),
                    // ),
                    onPressed: () => cancelBid(),
                    child: Text(
                      'Cancel Bid',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),

                  Text.rich(
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    TextSpan(
                      text: errorText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: errorColor,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 3,
                    thickness: 0.8,
                  ),
                  getSectionName("Details"),
                  getDetailsRow("Make", car.make),
                  getDetailsRowDivider(),
                  getDetailsRow("Model", car.model),
                  getDetailsRowDivider(),
                  getDetailsRow("Year", car.year),
                  getDetailsRowDivider(),
                  getDetailsRow("Color", car.color),
                  getDetailsRowDivider(),
                  getDetailsRow("Mileage", car.mileage.toString()),
                  getDetailsRowDivider(),
                  getDetailsRow("Transmission", car.transmission),
                  getDetailsRowDivider(),
                  getDetailsRow("Engine", car.engine),
                  getDetailsRowDivider(),
                  getDetailsRow("Payment Option", car.payment),
                  getDetailsRowDivider(),
                  getDetailsRow("Condition", car.condition),
                  const SizedBox(
                    height: 15,
                  ),
                  const Divider(
                    color: Colors.black,
                    height: 3,
                    thickness: 0.8,
                  ),
                  getSectionName("Seller"),
                  getSellerSection(currentUser),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
