import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mazadcar/screens/seller/addCarDetails.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';

class AddCarImage extends StatefulWidget {
  const AddCarImage({super.key});

  @override
  State<AddCarImage> createState() => _AddCarImageState();
}

class _AddCarImageState extends State<AddCarImage> {
  XFile? _imageFile;

  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      _imageFile = img;
    });
  }

  void toCarDetails(BuildContext myContext) {
    Navigator.of(myContext).push(MaterialPageRoute<void>(
      builder: (BuildContext context) => AddCarDetails(
        imagePath: _imageFile!.path,
        imageName: _imageFile!.name,
      ),
    ));
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
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
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

  @override
  Widget build(BuildContext context) {
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
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: _imageFile == null ? Colors.grey : Colors.black,
          onPressed: () {
            if (_imageFile != null) {
              toCarDetails(context);
            }
          },
          child: Icon(
            Icons.arrow_circle_right_outlined,
            color: Colors.white,
          )),
      body: Center(
        child:
            GridView.count(crossAxisCount: 1, mainAxisSpacing: 30, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                  child: Container(
                // padding: EdgeInsets.all(20),
                // margin: EdgeInsets.all(20),
                child: _imageFile != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            //to show image, you type like this.
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                          ),
                        ),
                      )
                    : Text(
                        "No Image",
                        style: TextStyle(fontSize: 20),
                      ),
              )),
              ElevatedButton(
                onPressed: () {
                  myAlert();
                },
                child: Text('Upload Photo'),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                  child: Container(
                child: _imageFile != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            //to show image, you type like this.
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                          ),
                        ),
                      )
                    : Text(
                        "No Image",
                        style: TextStyle(fontSize: 20),
                      ),
              )),
              ElevatedButton(
                onPressed: () {
                  myAlert();
                },
                child: Text('Upload Photo'),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                  child: Container(
                child: _imageFile != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            //to show image, you type like this.
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                          ),
                        ),
                      )
                    : Text(
                        "No Image",
                        style: TextStyle(fontSize: 20),
                      ),
              )),
              ElevatedButton(
                onPressed: () {
                  myAlert();
                },
                child: Text('Upload Photo'),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                  child: Container(
                child: _imageFile != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            //to show image, you type like this.
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                          ),
                        ),
                      )
                    : Text(
                        "Car  Image",
                        style: TextStyle(fontSize: 20),
                      ),
              )),
              ElevatedButton(
                onPressed: () {
                  myAlert();
                },
                child: Text('Upload Photo'),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )
        ]),
      ),
    );
  }
}
