import 'package:flutter/material.dart';
import 'package:mazadcar/Screens/Buyer/BidsPlaced.dart';
import 'package:mazadcar/Screens/Seller/soldCars.dart';

class MyTabbedPage extends StatefulWidget {
  const MyTabbedPage({super.key});
  @override
  State<MyTabbedPage> createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends State<MyTabbedPage>
    with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Ads Placed'),
    Tab(text: 'Bids Placed'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            flexibleSpace: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                new TabBar(
                  controller: _tabController,
                  tabs: myTabs,
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: myTabs.map((Tab tab) {
              final String label = tab.text!.toLowerCase();
              return label.compareTo("ads placed") == 0
                  ? SoldCars()
                  : BidsPlaced();
            }).toList(),
          ),
        ));
  }
}
