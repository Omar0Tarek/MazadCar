import 'package:flutter/material.dart';
import 'package:mazadcar/Chat/buyerChat.dart';
import 'package:mazadcar/Chat/sellerChat.dart';

import 'package:mazadcar/Screens/Seller/soldCars.dart';

class ChatTabBar extends StatefulWidget {
  const ChatTabBar({super.key});
  @override
  State<ChatTabBar> createState() => _chatTabCarState();
}

class _chatTabCarState extends State<ChatTabBar>
    with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Selling'),
    Tab(text: 'Buying'),
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
    return DefaultTabController(
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
              print(label);
              return label.compareTo("selling") == 0
                  ? SellerChat()
                  : BuyerChat();
            }).toList(),
          ),
        ));
  }
}
