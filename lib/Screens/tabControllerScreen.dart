import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mazadcar/Chat/chatTabBar.dart';
import 'package:mazadcar/Models/car.dart';
import 'package:mazadcar/Screens/Common/availableCars.dart';
import 'package:mazadcar/Screens/Common/myCars.dart';
import 'package:mazadcar/screens/MainDrawer.dart';
import 'package:mazadcar/screens/seller/SoldCars.dart';
import 'package:provider/provider.dart';

import 'Common/Chat.dart';
import 'Common/Saved.dart';

class TabControllerScreen extends StatefulWidget {
  const TabControllerScreen({super.key});

  @override
  State<TabControllerScreen> createState() => _TabControllerScreenState();
}

class _TabControllerScreenState extends State<TabControllerScreen> {
  List<Widget> myPages = [];

  var selectedTabIndex = 0;
  void switchPage(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    myPages = [AvailableCars(), MyCars(), Saved(), ChatTabBar()];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          selectedTabIndex == 0
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/filterCars');
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                )
              : Text(''),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
          )
        ],
        backgroundColor: Colors.white,
        title: Container(
          margin: EdgeInsets.all(15),
          padding:
              //  selectedTabIndex == 0
              //     ? EdgeInsets.only(left: 75, bottom: 20, top: 10)
              //     :
              EdgeInsets.only(left: 55, bottom: 20, top: 10),
          child: Image.asset(
            'assets/images/logo.png',
          ),
        ),
      ),
      body: myPages[selectedTabIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/addCarImage');
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home_filled,
                color: Colors.white,
              ),
              onPressed: () {
                if (selectedTabIndex != 0) {
                  setState(() {
                    selectedTabIndex = 0;
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.car_rental_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                if (selectedTabIndex != 1) {
                  setState(() {
                    selectedTabIndex = 1;
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.bookmark,
                color: Colors.white,
              ),
              onPressed: () {
                if (selectedTabIndex != 2) {
                  setState(() {
                    selectedTabIndex = 2;
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.chat_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                if (selectedTabIndex != 3) {
                  setState(() {
                    selectedTabIndex = 3;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


   // BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: Column(
      //           children: [
      //             Icon(
      //               Icons.home_filled,
      //               color: Colors.black,
      //             ),
      //             Container(
      //                 padding: EdgeInsets.only(top: 10), child: Text("HOME"))
      //           ],
      //         ),
      //         label: "Home"),
      //     BottomNavigationBarItem(
      //         icon: Column(
      //           children: [
      //             Icon(
      //               Icons.car_rental,
      //               color: Colors.black,
      //             ),
      //             Container(
      //                 padding: EdgeInsets.only(top: 10), child: Text("MY CARS"))
      //           ],
      //         ),
      //         label: "My Cars"),
      //     BottomNavigationBarItem(
      //         icon: Column(
      //           children: [
      //             Icon(
      //               Icons.saved_search,
      //               color: Colors.black,
      //             ),
      //             Container(
      //                 padding: EdgeInsets.only(top: 10), child: Text("SAVED"))
      //           ],
      //         ),
      //         label: "Saved"),
      //     BottomNavigationBarItem(
      //         icon: Column(
      //           children: [
      //             Icon(
      //               Icons.chat_outlined,
      //               color: Colors.black,
      //             ),
      //             Container(
      //                 padding: EdgeInsets.only(top: 10), child: Text("CHATS"))
      //           ],
      //         ),
      //         label: "Chat")
      //   ],
      //   currentIndex: selectedTabIndex,
      //   onTap: switchPage,
      // ),
