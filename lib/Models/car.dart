import 'dart:math';

class Car {
  final String id;

  // Car Info
  final String name;
  final String make;
  final String model;
  final String color;
  final String year;
  final int mileage;
  final String transmission;
  final String engine;

  // Ad Info
  final String sellerId;
  final int startPrice;
  final Map<String, int> bids;
  final DateTime startDate;
  final DateTime endDate;

  final String location;
  final String imageURL; // to be turned into a list

  final String comments; // to be turned into a list

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
    required this.location,
    required this.imageURL,
    required this.comments,
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
}
