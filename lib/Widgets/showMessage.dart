import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mazadcar/Models/chat.dart';
import 'package:mazadcar/Models/message.dart';
import 'package:mazadcar/Models/userModel.dart';
import 'package:mazadcar/Widgets/viewMessageImage.dart';

class ShowMessages extends StatefulWidget {
  final Chat chatroom;
  // final User chatuser;
  final UserModel targetuser;

  const ShowMessages({
    Key? key,
    required this.chatroom,
    // required this.chatuser,
    required this.targetuser,
  }) : super(key: key);

  @override
  State<ShowMessages> createState() => _ShowMessagesState();
}

class _ShowMessagesState extends State<ShowMessages> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  @override
  void initState() {
    stream = FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chatroom.id)
        .collection("messages")
        .orderBy("timeStamp", descending: true)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
              return ListView.builder(
                  reverse: true,
                  itemCount: datasnapshot.docs.length,
                  itemBuilder: (context, index) {
                    Message newmessage = Message.constructFromFirebase(
                        datasnapshot.docs[index].data() as Map<String, dynamic>,
                        datasnapshot.docs[index].reference.id);
                    return Row(
                      mainAxisAlignment: (newmessage.senderID ==
                              FirebaseAuth.instance.currentUser!.uid)
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                              color: (newmessage.senderID ==
                                      FirebaseAuth.instance.currentUser!.uid)
                                  ? Color(0xff2865DC)
                                  : Color(0xffFFFFFF),
                              borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: (newmessage.senderID ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                      ? Color(0xffE4E9F6)
                                      : Color(0xffE1E1E1),
                                  blurRadius: 10,
                                  blurStyle: BlurStyle.normal,
                                  offset: Offset(0, 4),
                                ),
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              (newmessage.image == null &&
                                      newmessage.content.toString().isNotEmpty)
                                  ? Text(
                                      newmessage.content.toString(),
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: (newmessage.senderID ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ViewMessagePic(
                                            image: newmessage.image.toString(),
                                          );
                                        }));
                                      },
                                      child: Image.network(
                                        newmessage.image.toString(),
                                        width: 250,
                                        height: 330,
                                      ),
                                    ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                //crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    DateFormat.jm()
                                        .format(newmessage.timeStamp!),
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w300,
                                      color: (newmessage.senderID ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  (newmessage.senderID ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                      ? Icon(
                                          Icons.check,
                                          size: 16,
                                          color: (newmessage.senderID ==
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid)
                                              ? Colors.white
                                              : Colors.black,
                                        )
                                      : Text(""),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  });
            } else if (snapshot.hasError) {
              return Text("Internet Connection Error");
            } else {
              return Text("Say Hi");
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }
}
