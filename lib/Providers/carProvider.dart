import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mazadcar/Screens/tabControllerScreen.dart';
import 'package:mazadcar/Models/car.dart';

class CarProvider with ChangeNotifier {
  List<Car> _cars = [];

// Realtime DB Link: https://mazadcar-60190-default-rtdb.firebaseio.com/

  Future<void> fetchCarsFromServer() async {
    try {
      final carsURL = Uri.parse(
          "https://mazadcar-60190-default-rtdb.firebaseio.com/cars.json");
      var response = await http.get(carsURL);
      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      _cars.clear();
      print("fetched data");
      print(fetchedData);
      fetchedData.forEach((key, value) {
        _cars.add(
          Car(
              id: key,
              make: value['make'],
              model: value['model'],
              year: value['year'],
              mileage: value['mileage'],
              color: value['color'],
              sellerId: value['sellerId'],
              imageURL: value['imageURL'],
              location: value['location'],
              transmission: value['transmission'],
              engine: value['engine'],
              startPrice: value['startPrice'],
              comments: value['comments']),
        );
      });
      print(_cars);
      notifyListeners();
    } catch (err) {}
  }

  Future<void> addCar(
      String make,
      String model,
      String year,
      int mileage,
      String color,
      String sellerId,
      String imageURL,
      String location,
      String transmission,
      String engine,
      String startPrice,
      String comments) {
    final carsURL = Uri.parse(
        "https://mazadcar-60190-default-rtdb.firebaseio.com/cars.json");
    return http
        .post(carsURL,
            body: json.encode({
              'make': make,
              'model': model,
              'year': year,
              'mileage': mileage,
              'color': color,
              'sellerId': sellerId,
              'imageURL': imageURL,
              'location': location,
              'transmission': transmission,
              'engine': engine,
              'startPrice': startPrice
            }))
        .then((value) {
      _cars.add(Car(
          id: json.decode(value.body)['name'],
          make: make,
          model: model,
          year: year,
          mileage: mileage,
          color: color,
          sellerId: sellerId,
          imageURL: imageURL,
          location: location,
          transmission: transmission,
          engine: engine,
          startPrice: startPrice,
          comments: comments));
      notifyListeners();
    }).catchError((err) {
      throw err;
    });
  }

  Future<void> updateCar(String to_update, Car car) async {
    var carToUpdateURL = Uri.parse(
        "https://mazadcar-60190-default-rtdb.firebaseio.com/cars/$to_update.json");
    try {
      await http.put(carToUpdateURL,
          body: json.encode({
            'make': car.make,
            'model': car.model,
            'year': car.year,
            'mileage': car.mileage,
            'color': car.color,
            'sellerId': car.sellerId,
            'imageURL': car.imageURL,
            'location': car.location,
            'transmission': car.transmission,
            'engine': car.engine,
            'startPrice': car.startPrice
          }));
    } catch (err) {
      print(err);
    }
  }

  List<Car> get getAllCars {
    return _cars;
  }

  void deleteCar(String id_to_delete) async {
    var carToDeleteURL = Uri.parse(
        "https://mazadcar-60190-default-rtdb.firebaseio.com/cars/$id_to_delete.json");

    try {
      await http
          .delete(carToDeleteURL); // wait for the delete request to be done
      _cars.removeWhere((element) {
        // when done, remove it locally.
        return element.id == id_to_delete;
      });
      notifyListeners(); // to update our list without the need to refresh
    } catch (err) {}
  }

  Future<void> fetchMycarsFromServer(String userId) async {
    var carsURL = Uri.parse(
        'https://mazadcar-60190-default-rtdb.firebaseio.com/cars.json?orderBy="userId"&equalTo="$userId"');
    try {
      var response = await http.get(carsURL);

      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      _cars.clear();
      fetchedData.forEach((key, value) {
        _cars.add(Car(
            id: key,
            make: value['make'],
            model: value['model'],
            year: value['year'],
            mileage: value['mileage'],
            color: value['color'],
            sellerId: value['sellerId'],
            imageURL: value['imageURL'],
            location: value['location'],
            transmission: value['transmission'],
            engine: value['engine'],
            startPrice: value['startPrice'],
            comments: value['comments']));
      });
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }
}
