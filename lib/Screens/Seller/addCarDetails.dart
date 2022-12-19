import 'dart:collection';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mazadcar/providers/storage.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

import '../../providers/carProvider.dart';

class AddCarDetails extends StatefulWidget {
  String imageName;
  String imagePath;

  AddCarDetails({required this.imageName, required this.imagePath});
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

  @override
  Widget build(BuildContext context) {
    final carsProvider = Provider.of<CarProvider>(context, listen: false);
    Storage storage = Storage();

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
                storage
                    .uploadImageToFirebase(widget.imagePath, widget.imageName)
                    .then((value) => print("Done"));
                carsProvider
                    .addCar(
                        makeValue.text,
                        modelValue.text,
                        yearValue.text,
                        int.parse(mileageValue.text),
                        colorValue.text,
                        sellerIdValue.text,
                        widget.imageName,
                        locationValue.text,
                        transmissionValue.text,
                        engineValue.text,
                        startPriceValue.text,
                        commentsValue.text)
                    .catchError((err) {
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
                          decoration: InputDecoration(labelText: "Start Price"),
                          controller: startPriceValue,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        child: TextField(
                          decoration: InputDecoration(labelText: "Seller"),
                          controller: sellerIdValue,
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
            ),
    );
  }
}
