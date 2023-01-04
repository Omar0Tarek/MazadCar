// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mazadcar/Models/car.dart';
import 'package:mazadcar/Models/userModel.dart';

class TargetUser extends StatefulWidget {
  UserModel targetUser;
  Car ad;

  TargetUser({required this.targetUser, required this.ad});
  @override
  State<TargetUser> createState() => _TargetUserState();
}

class _TargetUserState extends State<TargetUser> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "User Info",
            style: GoogleFonts.inter(
              fontSize: 24,
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
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/carAdPage',
                            arguments: {'car': widget.ad});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.network(
                            jsonDecode(widget.ad.imageURL)[0].toString(),
                            width: 70,
                            height: 60,
                          ),
                          Spacer(),
                          Text(
                            widget.ad.make +
                                " " +
                                widget.ad.model +
                                " " +
                                widget.ad.year,
                            style: TextStyle(color: Colors.black),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_right,
                            color: Colors.black,
                          )
                        ],
                      )),
                  const Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        widget.targetUser.profilepic,
                        fit: BoxFit.cover,
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  ListTile(
                    //isThreeLine: true,
                    iconColor: Colors.black,
                    leading: const Icon(Icons.person),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Full Name",
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(widget.targetUser.name)
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    iconColor: Colors.black,
                    leading: const Icon(Icons.phone_iphone),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone Number",
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(widget.targetUser.phone)
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(widget.targetUser.email)
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
