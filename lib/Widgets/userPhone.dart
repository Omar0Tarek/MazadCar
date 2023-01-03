import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPhone extends StatefulWidget {
  const UserPhone({super.key});

  @override
  State<UserPhone> createState() => _UserPhoneState();
}

class _UserPhoneState extends State<UserPhone> {
  Stream<DocumentSnapshot> _phoneStream() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _phoneStream(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Text("No Internet Connection");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          return Icon(Icons.person);
        }
        dynamic data = snapshot.data;
        return Text(
          (data['phone'] == null) ? "" : data['phone'],
        );
      },
    );
  }
}
