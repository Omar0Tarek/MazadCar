import 'dart:convert';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mazadcar/Chat/chatPage.dart';

import 'package:mazadcar/Models/car.dart';
import 'package:mazadcar/Models/chat.dart';
import 'package:mazadcar/Models/userModel.dart';

class BuyerChat extends StatefulWidget {
  @override
  State<BuyerChat> createState() => _BuyerChatState();
}

class _BuyerChatState extends State<BuyerChat> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      final user = auth.currentUser;
      stream = FirebaseFirestore.instance
          .collection("chats")
          .where("buyerID", isEqualTo: user!.uid)
          .snapshots();
    }
    super.initState();
  }

  static Future<dynamic?> getUserModelbyId(
      String uid, String carAdID, String currID) async {
    UserModel? chatUser;
    Car? car;
    UserModel? currentUser;

    DocumentSnapshot docsnapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (docsnapshot.data() != null) {
      var user = docsnapshot.data();

      chatUser = UserModel.constructFromFirebase(
          user as Map, docsnapshot.reference.id);
    }

    DocumentSnapshot docsnapshotCar =
        await FirebaseFirestore.instance.collection("cars").doc(carAdID).get();

    if (docsnapshotCar.data() != null) {
      var carData = docsnapshotCar.data();

      car = Car.constructFromFirebase(
          carData as Map, docsnapshotCar.reference.id);
    }

    DocumentSnapshot docsnapshotCurrent =
        await FirebaseFirestore.instance.collection("users").doc(currID).get();

    if (docsnapshotCurrent.data() != null) {
      var user = docsnapshotCurrent.data();

      currentUser = UserModel.constructFromFirebase(
          user as Map, docsnapshotCurrent.reference.id);
    }

    return [chatUser, car, currentUser];
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null
        ? Container(
            child: StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    );
                  } else {
                    QuerySnapshot chatsSnapshot =
                        snapshot.data as QuerySnapshot;
                    var chatList = snapshot.data!.docs;
                    print(chatList);
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        var chatsPopulated = Chat.constructFromFirebase(
                            chatList[index].data() as Map,
                            chatList[index].reference.id);
                        print(chatsPopulated);
                        var receiver = chatsPopulated.sellerID;
                        return FutureBuilder(
                            future: getUserModelbyId(receiver,
                                chatsPopulated.adID, chatsPopulated.buyerID),
                            builder: (context, userdata) {
                              if (userdata.connectionState ==
                                  ConnectionState.done) {
                                if (userdata.data != null) {
                                  UserModel targetuser =
                                      userdata.data[0] as UserModel;
                                  Car carAD = userdata.data[1] as Car;
                                  List<dynamic> images =
                                      jsonDecode(carAD.imageURL);

                                  return Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey, //New
                                              blurRadius: 5.0,
                                              offset: Offset(0, 10))
                                        ],
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                        left: 10,
                                        bottom: 5,
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: ((context) {
                                                return ChatPage(
                                                  targetuser: targetuser,
                                                  chat: chatsPopulated,
                                                  currentUser: userdata.data[2],
                                                  ad: userdata.data[1],
                                                  // currentUser: userdata.data[2],
                                                );
                                              }),
                                            ),
                                          );
                                        },
                                        leading: CircleAvatar(
                                          radius: 35,
                                          backgroundImage: NetworkImage(
                                            images[0].toString(),
                                          ),
                                        ),
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              carAD.make +
                                                  " " +
                                                  carAD.model +
                                                  " " +
                                                  carAD.year,
                                            ),
                                          ],
                                        ),
                                        subtitle: (chatsPopulated.lastMessage ==
                                                null)
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                ),
                                                child: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.image,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "Image",
                                                    ),
                                                    SizedBox(
                                                      width: 40,
                                                    ),
                                                    Text(""),
                                                  ],
                                                ))
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    chatsPopulated.lastMessage
                                                        .toString(),
                                                  ),
                                                  Text(
                                                    (chatsPopulated
                                                                .lastMessageDate ==
                                                            null)
                                                        ? "lopp"
                                                        : DateFormat.jm().format(
                                                            chatsPopulated
                                                                .lastMessageDate),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Text("User data is null");
                                }
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            });
                      },
                      itemCount: chatsSnapshot.docs.length,
                    );
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                      child: Text("Error: Check Internet Connection"));
                }
              },
            ),
          )
        : SizedBox(
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
          );
  }
}
