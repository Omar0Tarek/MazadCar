import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mazadcar/Models/car.dart';

class CarCard extends StatefulWidget {
  Car car;
  CarCard({required this.car});

  @override
  State<CarCard> createState() => _CarCardState(car: car);
}

class _CarCardState extends State<CarCard> {
  final Car car;

  _CarCardState({required this.car});

  void goToCarAdPage(BuildContext myContext) {
    Navigator.of(myContext).pushNamed('/carAdPage', arguments: {'car': car});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => goToCarAdPage(context),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: null,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Divider(
              color: Colors.black,
              height: 5,
              thickness: 1,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 160,
                  width: 130,
                  child: Image.network(
                    jsonDecode(widget.car.imageURL)[0],
                    fit: BoxFit.cover,
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
                              car.name,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text.rich(
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              TextSpan(
                                text: 'EGP ${car.getHighestBid().toString()}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF006E7F)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              "assets/images/car_ad_icons/icons8-engine-30.png",
                              height: 20,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Text.rich(
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                TextSpan(
                                  text: '  ${car.engine}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                )),
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              "assets/images/car_ad_icons/icons8-transmission-64.png",
                              height: 20,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Text.rich(
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                TextSpan(
                                  text: '  ${car.transmission}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              "assets/images/car_ad_icons/icons8-odometer-50.png",
                              height: 20,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Text.rich(
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                TextSpan(
                                  text: '  ${car.mileage}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                )),
                          ),
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              "assets/images/car_ad_icons/icons8-year-64.png",
                              height: 20,
                              color: Colors.grey,
                            ),
                          ),
                          // Expanded(
                          //   child: Container(
                          //     margin: const EdgeInsets.only(left: 16),
                          //     decoration: BoxDecoration(
                          //         color: Color(0xFFA10035),
                          //         borderRadius: const BorderRadius.all(
                          //             Radius.circular(5))),
                          //     padding: const EdgeInsets.all(3),
                          //     child: Text(
                          //       '2019',
                          //       style: TextStyle(
                          //           color: Color(0xFFFEC260),
                          //           fontSize: 10,
                          //           fontWeight: FontWeight.w500),
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: Text.rich(
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                TextSpan(
                                  text: '  ${car.year}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              car.getCountDown().toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                // backgroundColor: Color(0xFFFEC260),
                                color: Color(0xFFA10035),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.black,
              height: 5,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
