import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazadcar/Models/userModel.dart';
import 'package:mazadcar/Screens/Auth/AuthPage.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    print("check here " + FirebaseAuth.instance.currentUser!.uid);
    // print("hi " + FirebaseFirestore.instance.collection("users").doc().toString());

    var userProfile = FirebaseFirestore.instance
        .collection("users")
        // .doc(FirebaseAuth.instance.currentUser!.uid);
        // .("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid);
        .where("name", isEqualTo: "Amera");
    var myStream = userProfile.snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: myStream,
        builder: (ctx, strSnapshot) {
          if (strSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var userList = strSnapshot.data!.docs;
          print(userList);
          return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
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
                            style: TextStyle(color: Colors.black),
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
                                  title: Container(
                                    margin: EdgeInsets.all(15),
                                    padding: EdgeInsets.only(
                                        left: 55, bottom: 20, top: 10),
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                    ),
                                  ),
                                ),
                              );
                            }));
                          }),
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                ],
                backgroundColor: Colors.white,
              ),

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

              body: ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (itemCtx, index) {
                    UserModel userModel = UserModel.constructFromFirebase(
                        userList[index].data() as Map,
                        userList[index].reference.id);
                    return Column(
                      children: [
                        AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          toolbarHeight: 10,
                        ),
                        const Center(
                            child: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Text(
                                  'User Profile',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ))),
                        /////profile pic//////////////////////////////////////////////////////////////////
                        // InkWell(
                        //   // onTap: () {
                        //   //   navigateSecondPage(EditImagePage());
                        //   // },
                        //   child: Image.network(
                        //     jsonDecode(userModel.profilepic)[0],
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        //////////////////////////////////////////////////////////////////////////
                        buildUserInfoDisplay(userModel.name, 'Name'),
                        buildUserInfoDisplay(userModel.phone, 'Phone'),
                        buildUserInfoDisplay(userModel.email, 'Email'),
                        // Expanded(
                        //   child: buildAbout(user),
                        //   flex: 4,
                        // )
                      ],
                    );
                  }));
        });
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
              color: Colors.grey,
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
                color: Colors.grey,
                width: 1,
              ))),
              child: Row(children: [
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          // navigateSecondPage(editPage);
                        },
                        child: Text(
                          getValue,
                          style: TextStyle(fontSize: 16, height: 1.4),
                        ))),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                  size: 40.0,
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
