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

  static Car constructFromFirebase(Map<dynamic, dynamic> data) {
    print("This is the data:");
    print(data);
    return Car(
      id: data['id'] ?? "",
      name: data['name'] ?? "",
      make: data['make'] ?? "",
      model: data['model'] ?? "",
      year: data['year'] ?? "",
      mileage: 0,
      color: data['color'] ?? "",
      sellerId: data['sellerId'] ?? "",
      imageURL: 'https://carwow-uk-wp-3.imgix.net/Volvo-XC40-white-scaled.jpg',
      location: data['location'] ?? "",
      transmission: data['transmission'] ?? "",
      engine: data['engine'] ?? "",
      startPrice: 0,
      comments: data['comments'] ?? "",
      bids: Map(),
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    );
  }
}
