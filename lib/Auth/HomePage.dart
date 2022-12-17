import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton.icon(
        icon: Icon(Icons.outbond_outlined),
        label: Text('signout'),
        onPressed: (() => FirebaseAuth.instance.signOut()),
      ),
    );
  }
}
