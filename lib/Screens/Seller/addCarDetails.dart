import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mazadcar/Models/car.dart';
import 'package:mazadcar/Screens/Common/myCars.dart';
import 'package:mazadcar/Screens/tabControllerScreen.dart';
import 'package:mazadcar/providers/storage.dart';
import 'package:string_validator/string_validator.dart';

class AddCarDetails extends StatefulWidget {
  List<XFile>? images;
  Car? extractedCar;
  List<String>? toBeDeleted;

  AddCarDetails({required this.images, this.extractedCar, this.toBeDeleted});
  @override
  State<AddCarDetails> createState() => _AddCarDetailsState();
}

class _AddCarDetailsState extends State<AddCarDetails> {
  var startDate = "";
  var endDate = "";
  final modelValue = TextEditingController();
  final makeValue = TextEditingController();
  //yearpicker
  final yearValue = TextEditingController();
  final mileageValue = TextEditingController();
  final colorValue = TextEditingController();
  //buttons
  final engineValue = TextEditingController();
  //buttons
  final transmissionValue = TextEditingController();
  final startPriceValue = TextEditingController();
  //change loc to payment buttons
  final paymentValue = TextEditingController();
  final sellerIdValue = TextEditingController();
  //comments to conditions buttons
  final conditionValue = TextEditingController();

  static const List<Widget> engineButtons = <Widget>[
    Text('Manual'),
    Text('Automatic')
  ];

  static const List<Widget> transmissionButtons = <Widget>[
    Text('Benzine'),
    Text('Diesel'),
    Text('Electric'),
    Text('Hybrid')
  ];

  static const List<Widget> paymentButtons = <Widget>[
    Text('Cash'),
    Text('Installments')
  ];

  static const List<Widget> conditionButtons = <Widget>[
    Text('New'),
    Text('Used')
  ];

  final List<bool> _selectedEngine = <bool>[false, false];
  final List<bool> _selectedTransmission = <bool>[false, false, false, false];
  final List<bool> _selectedPayment = <bool>[false, false];
  final List<bool> _selectedCondition = <bool>[false, false];

  String checkButtonVal(List<Widget> buttons, List<bool> _selected) {
    Text val;
    final selectedControlIndex = _selected.indexWhere((selected) {
      return selected == true;
    });
    val = buttons[selectedControlIndex] as Text;

    print(val.data.toString());

    return val.data.toString();
  }

  var isLoading = false;

  Future<List<String>?> uploadFiles(List<XFile>? _images) async {
    var imageUrls = _images != null
        ? await Future.wait(_images.map((_image) => uploadFile(_image)))
        : null;

    return imageUrls;
  }

  Future<String> uploadFile(XFile _image) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('posts/${_image.path}');
    UploadTask uploadTask = storageReference.putFile(File(_image.path));
    await uploadTask.whenComplete(() => null);

    return await storageReference.getDownloadURL();
  }

  Future<void> deleteImageFromFirebase() async {
    if (widget.toBeDeleted != null) {
      print(widget.toBeDeleted);
      for (var image in widget.toBeDeleted!) {
        Reference photoRef = FirebaseStorage.instance.refFromURL(image);

        await photoRef.delete().then((value) => print("Done"));
      }
    }
  }

  void initState() {
    makeValue.text = widget.extractedCar != null
        ? widget.extractedCar!.make
        : makeValue.text;
    modelValue.text = widget.extractedCar != null
        ? widget.extractedCar!.model
        : modelValue.text;
    yearValue.text = widget.extractedCar != null
        ? widget.extractedCar!.year
        : yearValue.text;
    mileageValue.text = widget.extractedCar != null
        ? widget.extractedCar!.mileage.toString()
        : mileageValue.text;
    colorValue.text = widget.extractedCar != null
        ? widget.extractedCar!.color
        : colorValue.text;
    startDate = widget.extractedCar != null
        ? DateFormat().format(widget.extractedCar!.startDate)
        : "";
    endDate = widget.extractedCar != null
        ? DateFormat().format(widget.extractedCar!.endDate)
        : "";
    startPriceValue.text = widget.extractedCar != null
        ? widget.extractedCar!.startPrice.toString()
        : startPriceValue.text;
    if (widget.extractedCar != null) {
      if (widget.extractedCar!.engine == "Manual") {
        _selectedEngine[0] = true;
      } else {
        _selectedEngine[1] = true;
      }
    }

    if (widget.extractedCar != null) {
      if (widget.extractedCar!.payment == "Cash") {
        _selectedPayment[0] = true;
      } else {
        _selectedPayment[1] = true;
      }
    }

    if (widget.extractedCar != null) {
      if (widget.extractedCar!.condition == "New") {
        _selectedCondition[0] = true;
      } else {
        _selectedCondition[1] = true;
      }
    }

    if (widget.extractedCar != null) {
      if (widget.extractedCar!.transmission == "Benzine") {
        _selectedTransmission[0] = true;
      } else if (widget.extractedCar!.transmission == "Diesel") {
        _selectedTransmission[1] = true;
      } else if (widget.extractedCar!.transmission == "Electric") {
        _selectedTransmission[2] = true;
      } else {
        _selectedTransmission[3] = true;
      }
    }

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.toBeDeleted);

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          title: Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.only(left: 10, bottom: 20, top: 10),
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (FirebaseAuth.instance.currentUser != null) {
                    setState(() {
                      isLoading = true;
                    });

                    List<String> imagesNames = [];
                    uploadFiles(widget.images).then((value) {
                      if (widget.extractedCar != null) {
                        if (value != null) {
                          List<String> oldURL = [];

                          List<dynamic> images =
                              jsonDecode(widget.extractedCar!.imageURL);

                          print(widget.toBeDeleted);

                          for (String x in images) {
                            if (widget.toBeDeleted != null) {
                              if (!widget.toBeDeleted!.contains(x)) {
                                value.add(x);
                              }
                            } else {
                              value.add(x);
                            }
                          }
                        }
                      }

                      if (widget.extractedCar != null) {
                        print("updated");

                        deleteImageFromFirebase().then((x) {
                          FirebaseFirestore.instance
                              .collection("cars")
                              .doc(widget.extractedCar!.id)
                              .update({
                            'name': "name", // Seller should provide car name,
                            'make': makeValue.text,
                            'model': modelValue.text,
                            'year': yearValue.text,
                            'mileage': int.parse(mileageValue.text),
                            'color': colorValue.text,
                            'sellerId': FirebaseAuth.instance.currentUser!.uid,
                            'imageURL': jsonEncode(value),
                            'payment': checkButtonVal(
                                paymentButtons, _selectedPayment),
                            'transmission': checkButtonVal(
                                transmissionButtons, _selectedTransmission),
                            'engine':
                                checkButtonVal(engineButtons, _selectedEngine),
                            'startPrice': int.parse(startPriceValue.text),
                            'condition': checkButtonVal(
                                conditionButtons, _selectedCondition),
                            'bids': widget.extractedCar!.bids,
                            'startDate': DateFormat().parse(startDate),
                            'endDate': DateFormat().parse(endDate),
                          }).catchError((err) {
                            return showDialog(
                                context: context,
                                builder: ((ctx) {
                                  return AlertDialog(
                                    title: Text("An error occurred in update"),
                                    content: Text(
                                      err.toString(),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text("Okay"))
                                    ],
                                  );
                                }));
                          }).then((_) {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/', (route) => false);
                          });
                        });
                      } else {
                        print("curr user");
                        print(FirebaseAuth.instance.currentUser);
                        checkButtonVal(conditionButtons, _selectedCondition);
                        FirebaseFirestore.instance.collection("cars").add({
                          'name': "name", // Seller should provide car name,
                          'make': makeValue.text,
                          'model': modelValue.text,
                          'year': yearValue.text,
                          'mileage': int.parse(mileageValue.text),
                          'color': colorValue.text,
                          'sellerId': FirebaseAuth.instance.currentUser!.uid,
                          'imageURL': jsonEncode(value),
                          'payment':
                              checkButtonVal(paymentButtons, _selectedPayment),
                          'transmission': checkButtonVal(
                              transmissionButtons, _selectedTransmission),
                          'engine':
                              checkButtonVal(engineButtons, _selectedEngine),
                          'startPrice': int.parse(startPriceValue.text),
                          'condition': checkButtonVal(
                              conditionButtons, _selectedCondition),
                          'bids': Map(),
                          'startDate': DateFormat().parse(startDate),
                          'endDate': DateFormat().parse(endDate),
                        }).then((documentSnapshot) {
                          setState(() {
                            isLoading = false;
                          });

                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/', (route) => false);
                        }).catchError((err) {
                          return showDialog(
                              context: context,
                              builder: ((ctx) {
                                return AlertDialog(
                                  title: Text("An error occurred"),
                                  content: Text(
                                    err.toString(),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text("Okay"))
                                  ],
                                );
                              }));
                        });
                      }
                    });
                  } else {
                    showDialog(
                        context: context,
                        builder: ((ctx) {
                          return AlertDialog(
                            title: Text("Sign in first"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            '/', (route) => false);
                                  },
                                  child: Text("Cancel"))
                            ],
                          );
                        }));
                  }
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.black,
                ))
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 20),
                      margin: EdgeInsets.all(10),
                      child: Center(
                          child: Text("Add Car Details",
                              style: GoogleFonts.acme(
                                fontSize: 20,
                              )))),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: "Make"),
                            controller: makeValue,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: "Model"),
                            controller: modelValue,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: "Year"),
                            controller: yearValue,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: "Mileage"),
                            controller: mileageValue,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: "Color"),
                            controller: colorValue,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill';
                              }
                              return null;
                            },
                            decoration:
                                InputDecoration(labelText: "Start Price"),
                            controller: startPriceValue,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[700]),
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime(2023, 12, 31),
                                onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              setState(() {
                                startDate = DateFormat().format(date);
                              });
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Text(
                            'Start Date',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          startDate,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        margin: EdgeInsets.all(10),
                      )
                    ],
                  ),

                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[700]),
                            onPressed: () {
                              if (startDate != "") {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateFormat().parse(startDate),
                                    maxTime: DateTime(2023, 12, 31),
                                    onChanged: (date) {
                                  print('change $date');
                                }, onConfirm: (date) {
                                  setState(() {
                                    endDate = DateFormat().format(date);
                                  });
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                              }
                            },
                            child: Text(
                              'End Date',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          endDate,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        child: Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text(
                              "Engine",
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 5),
                            ToggleButtons(
                              onPressed: (int index) {
                                setState(() {
                                  // The button that is tapped is set to true, and the others to false.
                                  for (int i = 0;
                                      i < _selectedEngine.length;
                                      i++) {
                                    _selectedEngine[i] = i == index;
                                  }
                                });
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              selectedBorderColor: Colors.grey[700],
                              selectedColor: Colors.white,
                              fillColor: Colors.grey[700],
                              color: Colors.grey[400],
                              constraints: const BoxConstraints(
                                minHeight: 40.0,
                                minWidth: 80.0,
                              ),
                              isSelected: _selectedEngine,
                              children: engineButtons,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        child: Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text(
                              "Conditions",
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 5),
                            ToggleButtons(
                              onPressed: (int index) {
                                setState(() {
                                  // The button that is tapped is set to true, and the others to false.
                                  for (int i = 0;
                                      i < _selectedCondition.length;
                                      i++) {
                                    _selectedCondition[i] = i == index;
                                  }
                                });
                              },
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              selectedBorderColor: Colors.grey[700],
                              selectedColor: Colors.white,
                              fillColor: Colors.grey[700],
                              color: Colors.grey[400],
                              constraints: const BoxConstraints(
                                minHeight: 40.0,
                                minWidth: 80.0,
                              ),
                              isSelected: _selectedCondition,
                              children: conditionButtons,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          "Transmission",
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 5),
                        ToggleButtons(
                          onPressed: (int index) {
                            setState(() {
                              // The button that is tapped is set to true, and the others to false.
                              for (int i = 0;
                                  i < _selectedTransmission.length;
                                  i++) {
                                _selectedTransmission[i] = i == index;
                              }
                            });
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor: Colors.grey[700],
                          selectedColor: Colors.white,
                          fillColor: Colors.grey[700],
                          color: Colors.grey[400],
                          constraints: const BoxConstraints(
                            minHeight: 40.0,
                            minWidth: 80.0,
                          ),
                          isSelected: _selectedTransmission,
                          children: transmissionButtons,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text(
                          "Payment",
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 5),
                        ToggleButtons(
                          onPressed: (int index) {
                            setState(() {
                              // The button that is tapped is set to true, and the others to false.
                              for (int i = 0;
                                  i < _selectedPayment.length;
                                  i++) {
                                _selectedPayment[i] = i == index;
                              }
                            });
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor: Colors.grey[700],
                          selectedColor: Colors.white,
                          fillColor: Colors.grey[700],
                          color: Colors.grey[400],
                          constraints: const BoxConstraints(
                            minHeight: 40.0,
                            minWidth: 80.0,
                          ),
                          isSelected: _selectedPayment,
                          children: paymentButtons,
                        ),
                      ],
                    ),
                  ),
                  // )
                ],
              ));
  }
}
