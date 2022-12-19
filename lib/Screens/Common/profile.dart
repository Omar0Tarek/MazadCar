import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          ElevatedButton.icon(
            icon: Icon(Icons.outbond_outlined),
            label: Text('signout'),
            onPressed: (() {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, "/home", (Route<dynamic> route) => false);
            }),
          ),
        ],
        backgroundColor: Colors.white,
      ),
    );
  }
}
