import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mazadcar/Models/car.dart';

class OldAdCard extends StatefulWidget {
  Car car;
  OldAdCard({required this.car});

  @override
  State<OldAdCard> createState() => _OldAdCardState(car: car);
}

class _OldAdCardState extends State<OldAdCard> {
  final Car car;

  _OldAdCardState({required this.car});

  void goToCarAdPage(BuildContext myContext) {
    Navigator.of(myContext).pushNamed('/carAdPage', arguments: {'car': car});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => goToCarAdPage(context),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(),
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: Image.network(
                    jsonDecode(widget.car.imageURL)[0],
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              car.make + " " + car.model + " " + car.year,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Highest Bid",
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text.rich(
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  TextSpan(
                                    text:
                                        'EGP ${car.getHighestBid().toString()}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 5),
                              child: Text(
                                car.getCountDown().toString(),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  // backgroundColor: Color(0xFFFEC260),
                                  color: Color(0xFFA10035),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
