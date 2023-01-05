import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mazadcar/Models/car.dart';
import 'package:mazadcar/Screens/Seller/addCarDetails.dart';
import 'package:path/path.dart' as Path;

class addCarImages extends StatefulWidget {
  const addCarImages({super.key});

  @override
  State<addCarImages> createState() => _addCarImagesState();
}

class _addCarImagesState extends State<addCarImages> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  List<dynamic> savedImages = [];
  List<String> toBeDeleted = [];
  List<String> displayedImages = [];
  Car? extractedCar = null;

  void selectImages(String source) async {
    List<XFile>? selectedImages = [];
    if (source == "Gallery") {
      selectedImages = await imagePicker.pickMultiImage();
    } else {
      XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        selectedImages.add(image);
      }
    }

    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }

    setState(() {});
  }

  Future<void> deleteImageFromFirebase(String imageFileUrl) async {
    extractedCar = (ModalRoute.of(context)!.settings.arguments != null
        ? (ModalRoute.of(context)!.settings.arguments
            as Map<String, Object>)['Car']
        : null) as Car?;

    if (toBeDeleted.isNotEmpty) {
      if (toBeDeleted.contains(imageFileUrl)) {
        toBeDeleted.remove(imageFileUrl);
      } else {
        toBeDeleted.add(imageFileUrl);
      }
    } else {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        // savedImages = jsonDecode(extractedCar!.imageURL);
        // savedImages.remove(imageFileUrl);
        // extractedCar!.imageURL = jsonEncode(savedImages);
        toBeDeleted.add(imageFileUrl);
        print(toBeDeleted);
      }
    }
  }

  bool checkImages() {
    var images = savedImages.where((element) => !toBeDeleted.contains(element));
    if (images.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.black)),
                    onPressed: () {
                      Navigator.pop(context);
                      selectImages("Gallery");
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.black)),
                    onPressed: () {
                      Navigator.pop(context);
                      selectImages("Camera");
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void toCarDetails(
      BuildContext myContext, Car? extractedCar, List<String> tobeDeleted) {
    if (extractedCar != null) {
      print("toBeDeleted");
      print(toBeDeleted);
      Navigator.of(myContext).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => AddCarDetails(
          images: imageFileList,
          extractedCar: extractedCar,
          toBeDeleted: toBeDeleted,
        ),
      ));
    } else {
      Navigator.of(myContext).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => AddCarDetails(images: imageFileList),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    extractedCar = (ModalRoute.of(context)!.settings.arguments != null
        ? (ModalRoute.of(context)!.settings.arguments
            as Map<String, Object>)['Car']
        : null) as Car?;

    if (ModalRoute.of(context)!.settings.arguments != null) {
      savedImages = jsonDecode(extractedCar!.imageURL);
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Upload Car Images'),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: imageFileList!.isEmpty
                ? !checkImages()
                    ? Colors.grey
                    : Colors.black
                : Colors.black,
            onPressed: () {
              if (!imageFileList!.isEmpty || !savedImages!.isEmpty) {
                if (extractedCar != null) {
                  Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (BuildContext context) => AddCarDetails(
                      images: imageFileList,
                      extractedCar: extractedCar,
                      toBeDeleted: toBeDeleted,
                    ),
                  ));
                } else {
                  Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        AddCarDetails(images: imageFileList),
                  ));
                }
              }
            },
            child: Icon(
              Icons.arrow_circle_right_outlined,
              color: Colors.white,
            )),
        body: SafeArea(
          child: Column(
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.black)),
                onPressed: () {
                  myAlert();
                },
                child: Text('Select Images'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      border: Border.all(),
                    ),
                    child: GridView.builder(
                        itemCount: imageFileList!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: ((ctx) {
                                    return AlertDialog(
                                      title: Text("Delete Image"),
                                      content: Text(
                                          "Do you want to delete this image ?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                imageFileList?.removeAt(index);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Delete"))
                                      ],
                                    );
                                  }));
                            },
                            child: Image.file(
                              File(imageFileList![index].path),
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                  ),
                ),
              ),
              Expanded(
                  child: savedImages.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              border: Border.all(),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: GridView.builder(
                                  itemCount: savedImages.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: ((ctx) {
                                              return AlertDialog(
                                                title: toBeDeleted.isNotEmpty &&
                                                        toBeDeleted.contains(
                                                            savedImages[index])
                                                    ? Text(
                                                        "Undo Image Deletion")
                                                    : Text("Delete Image"),
                                                content: toBeDeleted
                                                            .isNotEmpty &&
                                                        toBeDeleted.contains(
                                                            savedImages[index])
                                                    ? Text(
                                                        "Do you want to undo this image deletion?")
                                                    : Text(
                                                        "Do you want to delete this image ?"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          deleteImageFromFirebase(
                                                              savedImages[
                                                                  index]);
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: toBeDeleted
                                                                  .isNotEmpty &&
                                                              toBeDeleted.contains(
                                                                  savedImages[
                                                                      index])
                                                          ? Text("Undo")
                                                          : Text("Delete"))
                                                ],
                                              );
                                            }));
                                      },
                                      child: toBeDeleted
                                              .contains(savedImages[index])
                                          ? Stack(children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          topRight:
                                                              Radius.circular(
                                                                  15)),
                                                  child: Image.network(
                                                      savedImages[index],
                                                      fit: BoxFit.cover)),
                                              Positioned.fill(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          topRight:
                                                              Radius.circular(
                                                                  15)),
                                                  child: Container(
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.close_sharp,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                bottom: 0,
                                              )
                                            ])
                                          : Image.network(
                                              savedImages[index],
                                            ),
                                    );
                                  }),
                            ),
                          ),
                        )
                      : Text("")),
            ],
          ),
        ));
  }
}
