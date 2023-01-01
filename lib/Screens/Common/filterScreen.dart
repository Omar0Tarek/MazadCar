import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:mazadcar/Models/car.dart';
import 'package:mazadcar/Providers/filter.dart';
import 'package:mazadcar/Screens/Auth/AuthPage.dart';
import 'package:mazadcar/Screens/Common/carCard.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  var makeValue;
  var map;
  late RangeValues rangeValues;
  Set<String> make = {};
  Set<String> model = {};
  Set<String> year = {};
  Set<String> transmission = {};
  Set<int> milage = {};
  Map<String, dynamic> appliedFilter = new Map();

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);
    var carInstances = FirebaseFirestore.instance.collection("cars");
    var myStream = carInstances.snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: myStream,
      builder: (ctx, strSnapshot) {
        if (strSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var carList = strSnapshot.data!.docs;
        var firstCar = carList[0].data() as Map;
        int minMileage = firstCar['mileage'];
        int maxMileage = firstCar['mileage'];

        carList.forEach((element) => {
              map = element.data() as Map,
              make.add(map['make']),
              if (map['mileage'] < minMileage) {minMileage = map['mileage']},
              if (map['mileage'] > maxMileage) {maxMileage = map['mileage']}
            });
        print(maxMileage);
        print(minMileage);
        rangeValues = RangeValues(10.0, 90.0);

        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            actions: [
              TextButton(
                onPressed: (() {
                  filterProvider.applyFilter(appliedFilter);
                  Navigator.of(context).pushNamed('/');
                }),
                child: Text(
                  'Apply filter',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
            backgroundColor: Colors.white,
          ),
          body: Column(
            children: [
              ListTile(
                title: Text('Make'),
                trailing: DropdownButton(
                  hint: Text('choose the make'),
                  items: make.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: ((value) => setState(() {
                        makeValue = value;
                        appliedFilter['make'] = value;
                      })),
                  value: makeValue,
                ),
              ),

              //title: Text('Mileage'),
              RangeSlider(
                values: rangeValues,
                labels: RangeLabels(
                  rangeValues.start.round().toString(),
                  rangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    rangeValues = values;
                  });
                },
                max: 100.0,
                min: 0.0,
                divisions: 10,
              ),
            ],
          ),
        );
      },
    );
  }
}
