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
    final user = auth.currentUser;
    stream = FirebaseFirestore.instance
        .collection("chats")
        .where("buyerID", isEqualTo: user!.uid)
        // .orderBy("lastMessageDate", descending: true)
        .snapshots();
    super.initState();
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

  static Future<Car?> getCarModelbyId(String uid) async {
    Car? car;

    DocumentSnapshot docsnapshot =
        await FirebaseFirestore.instance.collection("cars").doc(uid).get();

    if (docsnapshot.data() != null) {
      var carData = docsnapshot.data();

      car = Car.constructFromFirebase(carData as Map, docsnapshot.reference.id);
    }
    return car;
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    var chatInstances = FirebaseFirestore.instance.collection("chats");
    //  var myStream = chatInstances.snapshots();

    return Container(
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
              QuerySnapshot chatsSnapshot = snapshot.data as QuerySnapshot;
              var chatList = snapshot.data!.docs;
              print(chatList);
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  var chatsPopulated = Chat.constructFromFirebase(
                      chatList[index].data() as Map,
                      chatList[index].reference.id);
                  print(chatsPopulated);
                  var receiver = chatsPopulated.buyerID;
                  return FutureBuilder(
                      future: getUserModelbyId(receiver),
                      builder: (context, userdata) {
                        if (userdata.connectionState == ConnectionState.done) {
                          if (userdata.data != null) {
                            UserModel targetuser = userdata.data as UserModel;

                            return Padding(
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
                                        );
                                      }),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(
                                    targetuser.profilepic.toString(),
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      chatsPopulated.adName,
                                    ),
                                  ],
                                ),
                                subtitle: (chatsPopulated.lastMessage == null)
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            chatsPopulated.lastMessage
                                                .toString(),
                                          ),
                                          Text(
                                            (chatsPopulated.lastMessageDate ==
                                                    null)
                                                ? "lopp"
                                                : DateFormat.jm().format(
                                                    chatsPopulated
                                                        .lastMessageDate),
                                          ),
                                        ],
                                      ),
                                // trailing: Image.asset(
                                //   "car.png",
                                //   scale: 3.5,
                                // ),
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
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(child: Text("Error: Check Internet Connection"));
          }
        },
      ),
    );
  }
}
