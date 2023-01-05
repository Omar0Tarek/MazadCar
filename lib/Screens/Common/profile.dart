import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazadcar/Models/userModel.dart';
import 'package:mazadcar/Screens/Auth/AuthPage.dart';
import 'package:mazadcar/Widgets/editEmail.dart';
import 'package:mazadcar/Widgets/editImage.dart';
import 'package:mazadcar/Widgets/editName.dart';
import 'package:mazadcar/Widgets/editPhone.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserModel? user;

  Future<void> getUser() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      if (ds.data() != null) {
        var userM = ds.data();

        user = UserModel.constructFromFirebase(userM as Map, ds.reference.id);
      }
    });
  }

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      getUser();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("hi " + FirebaseFirestore.instance.collection("users").doc().toString());

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            FirebaseAuth.instance.currentUser != null
                ? TextButton(
                    onPressed: (() {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/", (Route<dynamic> route) => false);
                    }),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : TextButton(
                    onPressed: (() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Scaffold(
                          body: AuthPage(),
                          appBar: AppBar(
                            iconTheme: IconThemeData(color: Colors.black),
                            backgroundColor: Colors.white,
                            // title: Container(
                            //   margin: EdgeInsets.all(15),
                            //   padding: EdgeInsets.only(
                            //       left: 20, bottom: 20, top: 10),
                            //   child: Image.asset(
                            //     'assets/images/logo.png',
                            //   ),
                            // ),
                          ),
                        );
                      }));
                    }),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
          ],
          backgroundColor: Colors.black,
        ),

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        body: FirebaseAuth.instance.currentUser == null
            ? SizedBox(
                height: 200,
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Text(
                    "Sign in ",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 30),
                  )),
                ),
              )
            : user == null
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.black,
                  ))
                : Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        toolbarHeight: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      InkWell(
                        onTap: () {
                          navigateSecondPage(EditImagePage(
                            user: user!,
                          ));
                        },
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.network(
                            user!.profilepic,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //////////////////////////////////////////////////////////////////////////
                      buildUserInfoDisplay(user!.name, 'Name'),
                      buildUserInfoDisplay(user!.phone, 'Phone'),
                      buildUserInfoDisplay(user!.email, 'Email'),
                      // Expanded(
                      //   child: buildAbout(user),
                      //   flex: 4,
                      // )
                    ],
                  ));
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String getValue, String title) => Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Container(
              width: 350,
              height: 40,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.black,
                width: 1,
              ))),
              child: Row(children: [
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          "Email" == title
                              ? navigateSecondPage(
                                  EditEmailFormPage(user: user!))
                              : "Phone" == title
                                  ? navigateSecondPage(
                                      EditPhoneFormPage(user: user!))
                                  : navigateSecondPage(
                                      EditNameFormPage(user: user!));
                        },
                        child: Text(
                          getValue,
                          style: TextStyle(fontSize: 16, height: 1.4),
                        ))),
                Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: 20.0,
                )
              ]))
        ],
      ));

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
