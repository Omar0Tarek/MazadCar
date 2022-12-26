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

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: null,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: null,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Row(
              //   children: [
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Claim ID',
              //             style: TextStyle(
              //               fontSize: 12,
              //               fontWeight: FontWeight.w500,
              //               color: Colors.grey,
              //             ),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(top: 4.0),
              //             child: Text(
              //               'widget.claimNumber',
              //               style: const TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(
              //       width: 16,
              //     ),
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Contract No.',
              //             style: TextStyle(
              //               fontSize: 12,
              //               fontWeight: FontWeight.w500,
              //               color: Colors.grey,
              //             ),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(top: 4.0),
              //             child: Text(
              //               'KP2207514735',
              //               style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
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
                      widget.car.imageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                car.name,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            // Container(
                            //   margin: const EdgeInsets.only(left: 16),
                            //   decoration: BoxDecoration(
                            //       color: Colors.black,
                            //       borderRadius: const BorderRadius.all(
                            //           Radius.circular(5))),
                            //   padding: const EdgeInsets.all(3),
                            //   child: Text(
                            //     '2019',
                            //     style: TextStyle(
                            //         color: Colors.blueAccent,
                            //         fontSize: 10,
                            //         fontWeight: FontWeight.w500),
                            //   ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text.rich(
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                TextSpan(
                                  text: 'Engine: ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: car.engine,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text.rich(
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                TextSpan(
                                  text: 'Mileage: ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: car.mileage.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text.rich(
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                TextSpan(
                                    text: 'Transmission: ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: car.transmission,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
                                    ]),
                              ),
                            ),
                            // SizedBox(
                            //   width: 16,
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              children: [
                                // SizedBox(
                                //   width: 5,
                                // ),
                                // Expanded(
                                //   child: Text.rich(
                                //     // softWrap: false,
                                //     // overflow: TextOverflow.fade,
                                //     TextSpan(
                                //       text: car.getCountDown().toString(),
                                //       style: TextStyle(
                                //           // backgroundColor: Colors.red[800],
                                //           fontSize: 12,
                                //           fontWeight: FontWeight.w700,
                                //           color: Colors.red[800]),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                // Expanded(
                                //   child: Text.rich(
                                //     // softWrap: false,
                                //     // overflow: TextOverflow.fade,
                                //     TextSpan(
                                //       text: 'Remaining',
                                //       style: TextStyle(
                                //           // backgroundColor: Colors.red[800],
                                //           fontSize: 12,
                                //           fontWeight: FontWeight.w700,
                                //           color: Colors.red[800]),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text.rich(
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                TextSpan(
                                  text:
                                      '${car.getHighestBid().toString()} L.E.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red[800]),
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
              Divider(
                color: Colors.black,
                height: 5,
                thickness: 1,
              ),
            ],
          ),
        )
        // Card(
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        //   elevation: 4,
        //   margin: EdgeInsets.all(10),
        //   child: Column(children: [
        //     Stack(children: [
        //       ClipRRect(
        //         borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        //         child: Image.network(
        //           widget.car.imageURL,
        //           height: 250,
        //           width: double.infinity,
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //       Positioned.fill(
        //         bottom: 0,
        //         child: ClipRRect(
        //           borderRadius: BorderRadius.only(
        //               topLeft: Radius.circular(15),
        //               topRight: Radius.circular(15)),
        //           child: Container(
        //             color: Colors.black38,
        //             child: Center(
        //               child: Text(
        //                 widget.car.year +
        //                     " " +
        //                     widget.car.make +
        //                     " " +
        //                     widget.car.model,
        //                 softWrap: true,
        //                 overflow: TextOverflow.fade,
        //                 style: TextStyle(color: Colors.white, fontSize: 30),
        //                 textAlign: TextAlign.center,
        //               ),
        //             ),
        //           ),
        //         ),
        //       )
        //     ]),
        //     Container(
        //         margin: EdgeInsets.all(15),
        //         padding: EdgeInsets.all(15),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: [
        //             Column(
        //               children: [
        //                 Container(
        //                     padding: EdgeInsets.only(top: 10),
        //                     child: Text(widget.car.startPrice.toString())),
        //                 Container(
        //                     padding: EdgeInsets.only(top: 5),
        //                     child: Text("Start Price"))
        //               ],
        //             ),
        //             Column(
        //               children: [
        //                 Container(
        //                     padding: EdgeInsets.only(top: 10),
        //                     child: Text(widget.car.color)),
        //                 Container(
        //                     padding: EdgeInsets.only(top: 5),
        //                     child: Text("Color"))
        //               ],
        //             ),
        //             Column(
        //               children: [
        //                 Container(
        //                   padding: EdgeInsets.only(top: 5),
        //                   child: Text(widget.car.sellerId),
        //                 ),
        //                 Container(
        //                     padding: EdgeInsets.only(top: 5),
        //                     child: Text("Seller"))
        //               ],
        //             ),
        //             InkWell(
        //                 onTap: null,
        //                 child: Container(
        //                   child: Column(
        //                     children: [
        //                       Icon(Icons.favorite),
        //                       Container(
        //                           padding: EdgeInsets.only(top: 5),
        //                           child: Text("Favorites")),
        //                     ],
        //                   ),
        //                 ))
        //           ],
        //         ))
        //   ]),
        // ),
        );
  }
}
