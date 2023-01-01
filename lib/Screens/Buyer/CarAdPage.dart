import 'package:flutter/material.dart';
import 'package:mazadcar/Models/car.dart';

class CarAdPage extends StatefulWidget {
  const CarAdPage({super.key});

  @override
  State<CarAdPage> createState() => _CarAdPageState();
}

class _CarAdPageState extends State<CarAdPage> {
  late Car x;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
