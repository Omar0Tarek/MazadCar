import 'dart:convert';
import 'dart:math';

import 'package:flutter/src/widgets/editable_text.dart';

class Car {
  final String id;

  // Car Info
  final String name;
  final String make;
  final String model;
  final String color; //
  final String year; //
  final int mileage;
  final String transmission;
  final String engine;

  // Ad Info
  final String sellerId;
  final int startPrice; //
  final Map<String, int> bids;
  final DateTime startDate;
  final DateTime endDate;

  final String payment; // to be displayed
  String imageURL; // to be turned into a list

  final String condition;

  // Add Description field

  Car({
    required this.id,
    required this.name,
    required this.make,
    required this.model,
    required this.color,
    required this.year,
    required this.mileage,
    required this.transmission,
    required this.engine,
    required this.sellerId,
    required this.startPrice,
    required this.bids,
    required this.startDate,
    required this.endDate,
    required this.payment,
    required this.imageURL,
    required this.condition,
  });

  int getHighestBid() {
    return bids.isEmpty
        ? startPrice
        : bids.values.reduce((value, element) => max(value, element));
  }

  String getCountDown() {
    Duration diff = DateTime.now().difference(startDate);
    if (diff.isNegative) {
      diff = Duration.zero;
    }

    String countDown =
        '${diff.inHours}:${diff.inMinutes - diff.inHours * 60}:${diff.inSeconds - diff.inMinutes * 60}';

    return countDown;
  }

  static Car constructFromFirebase(Map<dynamic, dynamic> data, String id) {
    print("This is the data:");
    print(data);
    print(data['bids']);
    // print(jsonDecode(data['bids']));
    return Car(
      id: id,
      name: "This is a long name for testing",
      // data['name'] ?? "",
      make: data['make'] ?? "",
      model: data['model'] ?? "",
      year: data['year'] ?? "",
      mileage: data['mileage'],
      color: data['color'] ?? "",
      sellerId: data['sellerId'] ?? "",
      imageURL: data['imageURL'],
      payment: data['payment'] ?? "",
      transmission: data['transmission'] ?? "",
      engine: data['engine'] ?? "",
      startPrice: data['startPrice'],
      condition: data['condition'] ?? "",
      bids: Map<String, int>.from(data['bids']),
      startDate: data['startDate'].toDate() ?? DateTime.now(),
      endDate: data['endDate'].toDate() ?? DateTime.now(),
    );
  }

  void addBid(String uid, int bidValue) {
    bids[uid] = bidValue;
  }

  bool userHasBid(String biddingUserID) {
    return bids.containsKey(biddingUserID);
  }

  void cancelUserBid(String biddingUserID) {
    bids.remove(biddingUserID);
  }
}
