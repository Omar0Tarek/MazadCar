// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mazadcar/Chat/chatPage.dart';
import 'package:mazadcar/Models/car.dart';
import 'package:mazadcar/Models/chat.dart';
import 'package:mazadcar/Models/message.dart';
import 'package:mazadcar/Models/userModel.dart';
import 'package:uuid/uuid.dart';

class PreviewImage extends StatefulWidget {
  final XFile? picture;
  final Chat chatroom;
  final UserModel currentuser;
  final UserModel targetuser;
  final Car ad;
  const PreviewImage(
      {Key? key,
      required this.picture,
      required this.chatroom,
      required this.currentuser,
      required this.targetuser,
      required this.ad})
      : super(key: key);

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  void sendMessage() async {
    final File msgfile = File(widget.picture!.path);

    UploadTask uploadTask = FirebaseStorage.instance
        .ref("messagepics")
        .child(widget.chatroom.id.toString())
        .child(Uuid().v1())
        .putFile(msgfile);

    TaskSnapshot snapshot = await uploadTask;

    String? imgUrl = await snapshot.ref.getDownloadURL();

    Message newMessage = Message(
      id: Uuid().v1(),
      image: imgUrl,
      senderID: widget.currentuser.id,
      senderName: widget.currentuser.name,
      timeStamp: DateTime.now(),
    );

    Map<String, dynamic> mess = {
      "image": newMessage.image,
      "senderID": newMessage.senderID,
      "senderName": newMessage.senderName,
      "timeStamp": newMessage.timeStamp
    };

    await FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chatroom.id)
        .collection("messages")
        .doc(newMessage.id)
        .set(mess);

    widget.chatroom.lastMessageDate = DateTime.now();
    widget.chatroom.lastMessage = imgUrl;

    await FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chatroom.id)
        .set({
      "sellerID": widget.chatroom.sellerID,
      "buyerID": widget.chatroom.buyerID,
      "adID": widget.chatroom.adID,
      "lastMessage": widget.chatroom.lastMessage,
      "lastMessageDate": widget.chatroom.lastMessageDate,
      "adName": widget.chatroom.adName,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendMessage();
          Navigator.pop(context, MaterialPageRoute(builder: ((context) {
            return ChatPage(
                targetuser: widget.targetuser,
                chat: widget.chatroom,
                currentUser: widget.currentuser,
                ad: widget.ad);
          })));
        },
        backgroundColor: Color(0xff2865DC),
        child: Center(
          child: Image.asset(
            "assets/send1.png",
            width: 38,
            color: Colors.white,
            //height: 70,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Send Image',
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(
              File(widget.picture!.path),
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
            ),
            const SizedBox(height: 24),
            Text(widget.picture!.name)
          ],
        ),
      ),
    );
  }
}
