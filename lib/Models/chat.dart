import 'dart:convert';
import 'dart:math';

import 'package:mazadcar/Models/message.dart';

class Chat {
  final String id;

  // Car Info
  final String sellerID;
  final String buyerID;
  final String adID;
  String lastMessage;
  DateTime lastMessageDate;

  final String adName;

  Chat(
      {required this.id,
      required this.sellerID,
      required this.buyerID,
      required this.adID,
      required this.lastMessage,
      required this.lastMessageDate,
      required this.adName});

  static Chat constructFromFirebase(Map<dynamic, dynamic> data, String id) {
    print("This is the data:");
    print(data);

    // List<dynamic> messages = data['chats'];

    // List<Message> chats = [];

    // for (var element in messages) {
    //   Message x = Message(
    //       id: element["id"] ?? "",
    //       senderName: element['senderName'] ?? "",
    //       senderID: element['senderID'] ?? "",
    //       timeStamp: element['timeStamp'].toDate() ?? "",
    //       image: element['image'] ?? "",
    //       content: element['content'] ?? "");

    //   chats.add(x);
    // }

    return Chat(
      id: id,
      sellerID: data['sellerID'] ?? "",
      buyerID: data['buyerID'] ?? "",
      adID: data['adID'] ?? "",
      adName: data['adName'] ?? "",
      lastMessage: data['lastMessage'] ?? "",
      lastMessageDate: data['lastMessageDate'].toDate() ?? "",
    );
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'sellerID': sellerID,
  //     "buyerID": buyerID,
  //     "adID": adID,
  //     "adName": adName,
  //     'chats': chats.map((i) => i.toMap()).toList(),
  //   };
  // }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sellerID': sellerID,
      "buyerID": buyerID,
      "adID": adID,
      "adName": adName,
      "lastMessage": lastMessage,
      "lastMessageDate": lastMessageDate
    };
  }
}
