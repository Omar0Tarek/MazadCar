import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  var appliedMake;
  var appliedTransmission;
  var appliedMileage;
  var appliedLocation;
  var map;
  Set<String> make = {};
  Set<String> location = {};
  Set<String> year = {};
  Map<String, dynamic> appliedFilter = new Map();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mileageController = TextEditingController();

    final filterProvider = Provider.of<FilterProvider>(context);
    var carInstances = FirebaseFirestore.instance.collection("cars");
    var myStream = carInstances.snapshots();
    var filter = filterProvider.filter;

    if (filter['make'] != null && (appliedFilter['make'] == null)) {
      appliedMake = filter['make'];
      appliedFilter['make'] = filter['make'];
    }
    if (filter['transmission'] != null &&
        (appliedFilter['transmission'] == null)) {
      appliedTransmission = filter['transmission'];
      appliedFilter['transmission'] = filter['transmission'];
    }
    if (filter['location'] != null && (appliedFilter['location'] == null)) {
      appliedLocation = filter['location'];
      appliedFilter['location'] = filter['location'];
    }
    if (filter['maxMileage'] != null) {
      appliedMileage = filter['maxMileage'].toString();
      appliedFilter['maxMileage'] = filter['maxMileage'];
      mileageController.text = appliedMileage;
    }

    return StreamBuilder<QuerySnapshot>(
      stream: myStream,
      builder: (ctx, strSnapshot) {
        if (strSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var carList = strSnapshot.data!.docs;

        carList.forEach((element) => {
              map = element.data() as Map,
              make.add(map['make'].toString().toLowerCase()),
              location.add(
                map['location'].toString().toLowerCase(),
              )
            });

        make.add('All');
        location.add('All');

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
            body: InkWell(
                onTap: null,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: null,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.black,
                        height: 5,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Make:',
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: DropdownButton(
                                        underline: Container(
                                          color: Colors.white,
                                        ),
                                        hint: Text('Choose the make'),
                                        items: make
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: ((value) => setState(() {
                                              appliedMake = value;
                                              appliedFilter['make'] = value;
                                            })),
                                        value: appliedMake,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                        height: 5,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Mileage:',
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      children: [],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                        child: TextFormField(
                                      onChanged: (value) => {
                                        if (value.isNotEmpty)
                                          {
                                            appliedFilter['maxMileage'] =
                                                int.parse(value)
                                          }
                                        else
                                          appliedFilter['maxMileage'] = null
                                      },
                                      controller: mileageController,
                                      cursorColor: Colors.black,
                                      //controller: emailController,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          //labelText: 'Maximum Mileage',
                                          hintText: 'Maximum Mileage'),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ], // Only numbers can be entered
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                        height: 5,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Transmission:',
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: DropdownButton(
                                        underline: Container(
                                          color: Colors.white,
                                        ),
                                        hint: Text('Choose the transmission'),
                                        items: [
                                          DropdownMenuItem<String>(
                                            value: 'Manual',
                                            child: Text('Manual'),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: 'Automatic',
                                            child: Text('Automatic'),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: 'All',
                                            child: Text('All'),
                                          )
                                        ],
                                        onChanged: ((value) => setState(() {
                                              appliedFilter['transmission'] =
                                                  value;
                                              appliedTransmission = value;
                                            })),
                                        value: appliedTransmission,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                        height: 5,
                        thickness: 1,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Location:',
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: DropdownButton(
                                        underline: Container(
                                          color: Colors.white,
                                        ),
                                        hint: Text('Choose the location'),
                                        items: location
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: ((value) => setState(() {
                                              appliedLocation = value;
                                              appliedFilter['location'] = value;
                                            })),
                                        value: appliedLocation,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                  height: 5,
                                  thickness: 1,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )));
      },
    );
  }
}
