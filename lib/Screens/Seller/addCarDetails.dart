import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mazadcar/Models/car.dart';
import 'package:mazadcar/providers/storage.dart';

class AddCarDetails extends StatefulWidget {
  List<XFile>? images;
  Car? extractedCar;
  List<String>? toBeDeleted;

  AddCarDetails({required this.images, this.extractedCar, this.toBeDeleted});
  @override
  State<AddCarDetails> createState() => _AddCarDetailsState();
}

class _AddCarDetailsState extends State<AddCarDetails> {
  final modelValue = TextEditingController();

  final makeValue = TextEditingController();
  final yearValue = TextEditingController();
  final mileageValue = TextEditingController();
  final colorValue = TextEditingController();
  final engineValue = TextEditingController();
  final transmissionValue = TextEditingController();
  final startPriceValue = TextEditingController();
  final locationValue = TextEditingController();
  final sellerIdValue = TextEditingController();
  final commentsValue = TextEditingController();

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
    engineValue.text = widget.extractedCar != null
        ? widget.extractedCar!.engine
        : engineValue.text;
    transmissionValue.text = widget.extractedCar != null
        ? widget.extractedCar!.transmission
        : transmissionValue.text;
    startPriceValue.text = widget.extractedCar != null
        ? widget.extractedCar!.startPrice.toString()
        : startPriceValue.text;
    locationValue.text = widget.extractedCar != null
        ? widget.extractedCar!.location
        : locationValue.text;
    commentsValue.text = widget.extractedCar != null
        ? widget.extractedCar!.comments
        : commentsValue.text;

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
                  setState(() {
                    isLoading = true;
                  });

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
                            'location': locationValue.text,
                            'transmission': transmissionValue.text,
                            'engine': engineValue.text,
                            'startPrice': int.parse(startPriceValue.text),
                            'comments': commentsValue.text,
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
                        FirebaseFirestore.instance.collection("cars").add({
                          'name': "name", // Seller should provide car name,
                          'make': makeValue.text,
                          'model': modelValue.text,
                          'year': yearValue.text,
                          'mileage': int.parse(mileageValue.text),
                          'color': colorValue.text,
                          'sellerId': FirebaseAuth.instance.currentUser!.uid,
                          'imageURL': jsonEncode(value),
                          'location': locationValue.text,
                          'transmission': transmissionValue.text,
                          'engine': engineValue.text,
                          'startPrice': int.parse(startPriceValue.text),
                          'comments': commentsValue.text,
                          'bids': Map(),
                          'startDate': DateTime.now(),
                          'endDate': DateTime.now().add(Duration(hours: 1)),
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
                    print("No Authenticated  !!");
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
            : Wrap(
                runSpacing: 20,
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
                          child: TextField(
                            decoration: InputDecoration(labelText: "Make"),
                            controller: makeValue,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: TextField(
                            decoration: InputDecoration(labelText: "Model"),
                            controller: modelValue,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: TextField(
                            decoration: InputDecoration(labelText: "Year"),
                            controller: yearValue,
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
                          child: TextField(
                            decoration: InputDecoration(labelText: "Mileage"),
                            controller: mileageValue,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: TextField(
                            decoration: InputDecoration(labelText: "Color"),
                            controller: colorValue,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: TextField(
                            decoration: InputDecoration(labelText: "Engine"),
                            controller: engineValue,
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
                          child: TextField(
                            decoration:
                                InputDecoration(labelText: "Transmission"),
                            controller: transmissionValue,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: TextField(
                            decoration:
                                InputDecoration(labelText: "Start Price"),
                            controller: startPriceValue,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          child: TextField(
                            decoration: InputDecoration(labelText: "Location"),
                            controller: locationValue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    child: TextField(
                      decoration: InputDecoration(labelText: "Comments"),
                      controller: commentsValue,
                    ),
                  ),
                ],
              ));
  }
}
