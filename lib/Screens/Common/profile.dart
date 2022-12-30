import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mazadcar/Screens/Auth/AuthPage.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                            padding:
                                EdgeInsets.only(left: 55, bottom: 20, top: 10),
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
    );
  }
}
