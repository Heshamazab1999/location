import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_location/Model.dart';

// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  LocationData? _locationData;

  getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    var geolocator = Geolocator();

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream().listen((Position position) async {
      print(position == null
          ? 'Unknown'
          : position.latitude.toString() +
              ', ' +
              position.longitude.toString());
      await FirebaseFirestore.instance.collection('locations').doc("loc").set({
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
      final data = await FirebaseFirestore.instance
          .collection('locations')
          .doc("test")
          .get()
          .then((value) {
        Model model = Model.fromJson(value.data());
        if (kDebugMode) {
          print(model.latitude);
        }
      });
    });

    // location.onLocationChanged.listen((LocationData currentLocation) async {
    //   _locationData = currentLocation;
    //   if (kDebugMode) {
    //     print(_locationData);
    //   }
    //   await FirebaseFirestore.instance.collection('locations').doc("loc").set({
    //     'latitude': _locationData!.latitude,
    //     'longitude': _locationData!.longitude,
    //   });
    //   final data = await FirebaseFirestore.instance
    //       .collection('locations')
    //       .doc("test")
    //       .get()
    //       .then((value) {
    //     Model model = Model.fromJson(value.data());
    //     if (kDebugMode) {
    //       print(model.latitude);
    //     }
    //   });
    //   // Use current location
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset("assets/images/location.json"),
      ),
    );
  }
}
