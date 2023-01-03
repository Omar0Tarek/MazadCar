import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mazadcar/Models/car.dart';

class CarAdPage extends StatefulWidget {
  const CarAdPage({super.key});

  @override
  State<CarAdPage> createState() => _CarAdPageState();
}

class _CarAdPageState extends State<CarAdPage> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, Car>;
    Car car = routeArgs['car']!;

    getNameRow(String name) {
      return Container(
        margin: const EdgeInsets.all(8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            name,
            style: const TextStyle(
              color: Color(0xFF006E7F),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    // TO DO: Show Icons
    Widget getDetailsRow(String rowName, String rowValue) {
      return Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    rowName,
                    style: const TextStyle(
                      color: Color(0xFF006E7F),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    rowValue,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Color(0xFF006E7F),
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      );
    }

    getDetailsRowDivider() {
      return const Divider(
        color: Color(0xFF006E7F),
        height: 3,
        thickness: 0.5,
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: CarouselSlider(
                  options: CarouselOptions(
                    // height: 300.0,
                    aspectRatio: 4 / 3,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: [1, 2, 3, 4, 5].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          // margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(color: Colors.amber),
                          child: Image.network(
                            jsonDecode(car.imageURL)[0],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              getNameRow(car.name),
              getDetailsRow(car.location, car.startDate.toString()),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                color: Color(0xFF006E7F),
                height: 3,
                thickness: 0.8,
              ),
              getSectionName("Details"),
              getDetailsRow("Make", car.make),
              getDetailsRowDivider(),
              getDetailsRow("Model", car.model),
              getDetailsRowDivider(),
              getDetailsRow("Color", car.color),
              getDetailsRowDivider(),
              getDetailsRow("Year", car.year),
              getDetailsRowDivider(),
              getDetailsRow("Mileage", car.mileage.toString()),
              getDetailsRowDivider(),
              getDetailsRow("Transmission", car.transmission),
              getDetailsRowDivider(),
              getDetailsRow("Engine", car.engine),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                color: Color(0xFF006E7F),
                height: 3,
                thickness: 0.8,
              ),
              getSectionName("Description"),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                color: Color(0xFF006E7F),
                height: 3,
                thickness: 0.8,
              ),
              getSectionName("Seller Intro + Chat Button"),
            ],
          ),
        ),
      ),
    );
  }

  getSectionName(String sectionName) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          sectionName,
          style: const TextStyle(
            color: Color(0xFF006E7F),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
