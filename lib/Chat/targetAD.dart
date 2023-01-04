// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mazadcar/Models/car.dart';
import 'package:mazadcar/Models/userModel.dart';
import 'package:mazadcar/Widgets/userAbout.dart';

class TargetAD extends StatefulWidget {
  Car targetAD;

  TargetAD({required this.targetAD});
  @override
  State<TargetAD> createState() => _TargetADState();
}

class _TargetADState extends State<TargetAD> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Car AD Info",
            style: GoogleFonts.inter(
              fontSize: 20,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      jsonDecode(widget.targetAD.imageURL)[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ListTile(
                    //isThreeLine: true,

                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Car Model",
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(widget.targetAD.make +
                            " " +
                            widget.targetAD.model +
                            " " +
                            widget.targetAD.year),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Car Color",
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(widget.targetAD.color)
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sell Price",
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(widget.targetAD.getHighestBid().toString()),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/carAdPage',
                            arguments: {'car': widget.targetAD});
                      },
                      child: Text(
                        "More >",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
