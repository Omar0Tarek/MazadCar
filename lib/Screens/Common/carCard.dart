import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../Models/car.dart';

class CarCard extends StatefulWidget {
  Car car;
  CarCard({required this.car});

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: null,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(children: [
          Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Image.network(
                widget.car.imageURL,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: Container(
                  color: Colors.black38,
                  child: Center(
                    child: Text(
                      widget.car.year +
                          " " +
                          widget.car.make +
                          " " +
                          widget.car.model,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              bottom: 0,
            )
          ]),
          Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(widget.car.startPrice)),
                      Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text("Start Price"))
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(widget.car.color)),
                      Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text("Color"))
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(widget.car.sellerId),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Text("Seller"))
                    ],
                  ),
                  InkWell(
                      onTap: null,
                      child: Container(
                        child: Column(
                          children: [
                            Icon(Icons.favorite),
                            Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Text("Favorites")),
                          ],
                        ),
                      ))
                ],
              ))
        ]),
      ),
    );
  }
}
