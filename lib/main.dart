import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:mazadcar/Chat/buyerChat.dart';
import 'package:mazadcar/Providers/filter.dart';
import 'package:mazadcar/Screens/Auth/Utils.dart';
import 'package:mazadcar/Screens/Common/filterScreen.dart';
import 'package:mazadcar/Screens/Buyer/CarAdPage.dart';
import 'package:mazadcar/Screens/Common/profile.dart';
import 'package:mazadcar/Screens/Seller/addCarImage.dart';
import 'package:mazadcar/Screens/tabControllerScreen.dart';
import 'package:provider/provider.dart';

import 'Chat/chatTabBar.dart';
import 'Screens/Auth/AuthPage.dart';
import 'Screens/Auth/ForgotPassword.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(background_notif_handler);
  runApp(const MyApp());
}

Future<void> background_notif_handler(RemoteMessage message) async {
//await Firebase.initializeApp();
  print("Handling a background message: ${message.data}");
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (ctx) => FilterProvider(),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          scaffoldMessengerKey: Utils.messengerKey,
          title: 'MazadCar',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => MyHomePage(
                  title: 'Flutter Demo Home Page',
                ),
            '/addCarImage': (ctx) => addCarImages(),
            '/profile': (ctx) => Profile(),
            '/forgotPassword': (ctx) => ForgotPassword(),
            '/filterCars': (ctx) => FilterScreen(),
            '/carAdPage': (dummyctx) => CarAdPage(),
            '/chat': (dummyctx) => ChatTabBar(),
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        else if (snapshot.hasError)
          return Center(child: Text("Something went wrong"));
        else if (snapshot.hasData) {
          return TabControllerScreen();
        } else
          return TabControllerScreen();
      },
    ));
  }
}
