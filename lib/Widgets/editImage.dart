import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mazadcar/Models/userModel.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:image_picker/image_picker.dart';

class EditImagePage extends StatefulWidget {
  UserModel user;
  EditImagePage({Key? key, required this.user}) : super(key: key);

  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  Future<String> uploadFile(XFile _image) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('posts/${_image.path}');
    UploadTask uploadTask = storageReference.putFile(File(_image.path));
    await uploadTask.whenComplete(() => null);

    return await storageReference.getDownloadURL();
  }

  void updateUserValue(String image) {
    widget.user.profilepic = image;

    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "email": widget.user.email,
      "name": widget.user.name,
      "phone": widget.user.phone,
      "profilepic": widget.user.profilepic
    });
  }

  var image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Edit Image"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                  width: 330,
                  child: GestureDetector(
                    onTap: () async {
                      image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      setState(() {});
                      if (image == null) return;

                      // final location = await getApplicationDocumentsDirectory();
                      // final name = basename(image.path);
                      // final imageFile = File('${location.path}/$name');
                      // final newImage =
                      //     await File(image.path).copy(imageFile.path);
                      // setState(

                      //     () => widget.user = widget.user.copy(imagePath: newImage.path));
                    },
                    child: image != null
                        ? Image.file(
                            File(image.path),
                            fit: BoxFit.cover,
                          )
                        : Image.network(widget.user.profilepic),
                  ))),
          Padding(
              padding: EdgeInsets.only(top: 40),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          uploadFile(image).then((value) {
                            updateUserValue(value);
                            Navigator.pop(context);
                          });
                        });
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }
}
