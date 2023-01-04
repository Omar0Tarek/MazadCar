// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:mazadcar/Models/car.dart';
// import 'package:mazadcar/Screens/Common/carCard.dart';
// import 'package:mazadcar/Screens/Common/myCars.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SoldCars extends StatefulWidget {
//   const SoldCars({super.key});

//   @override
//   State<SoldCars> createState() => _SoldCarsState();
// }

// class _SoldCarsState extends State<SoldCars> {
//   bool isLoading = false;
//   Future<void> deleteImageFromFirebase(List<dynamic> toBeDeleted) async {
//     if (toBeDeleted != null) {
//       for (var image in toBeDeleted!) {
//         Reference photoRef = FirebaseStorage.instance.refFromURL(image);

//         await photoRef.delete().then((value) => print("Done"));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var carInstances = FirebaseFirestore.instance
//         .collection("cars")
//         .where("sellerId", isEqualTo: FirebaseAuth.instance.currentUser!.uid);
//     var myStream = carInstances.snapshots();

//     return StreamBuilder<QuerySnapshot>(
//       stream: myStream,
//       builder: (ctx, strSnapshot) {
//         if (strSnapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         var carList = strSnapshot.data!.docs;

//         return isLoading
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : ListView.builder(
//                 itemBuilder: (itemCtx, index) {
//                   Car car = Car.constructFromFirebase(
//                       carList[index].data() as Map,
//                       carList[index].reference.id);
//                   return Container(
//                     padding: const EdgeInsets.all(10),
//                     margin: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.grey, //New
//                               blurRadius: 5.0,
//                               offset: Offset(0, 10))
//                         ],
//                         // border: Border.all(
//                         //   color: Colors.black,
//                         // ),
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(15),
//                         ),
//                         color: Colors.black),
//                     child: Column(
//                       children: [
//                         CarCard(car: car),
//                         car.getCountDown() != "0:0:0"
//                             ? Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   IconButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pushNamed(
//                                           '/addCarImage',
//                                           arguments: {'Car': car});
//                                     },
//                                     icon: Icon(
//                                       Icons.edit,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         isLoading = true;
//                                       });

//                                       deleteImageFromFirebase(
//                                               jsonDecode(car.imageURL))
//                                           .then((value) {
//                                         FirebaseFirestore.instance
//                                             .collection("cars")
//                                             .doc(car.id)
//                                             .delete();
//                                       }).then((_) {
//                                         setState(() {
//                                           isLoading = false;
//                                         });
//                                         // Navigator.of(context)
//                                         //     .pushReplacement(MaterialPageRoute<void>(
//                                         //   builder: (BuildContext context) => MyCars(),
//                                         // ));
//                                         Navigator.of(context)
//                                             .pushNamedAndRemoveUntil(
//                                                 '/', (route) => false);
//                                       });
//                                     },
//                                     icon: Icon(
//                                       Icons.delete,
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : Text("")
//                       ],
//                     ),
//                   );
//                 },
//                 itemCount: carList.length,
//               );
//       },
//     );
//   }
// }
