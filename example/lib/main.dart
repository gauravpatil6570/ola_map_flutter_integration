import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ola_maps_flutter_plugin/ola_maps_flutter_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Completer<OlaMapController> _controller = Completer<OlaMapController>();

  LatLng initialPos = LatLng(latitude: 18.5204, longitude: 73.8567);

  @override
  void initState() {
    super.initState();
    setInitialPos();
  }

  void setInitialPos() async {
    await Geolocator.requestPermission();
    final postion = await Geolocator.getCurrentPosition();
    setState(() {
      initialPos =
          LatLng(latitude: postion.latitude, longitude: postion.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: OlaMap(
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
                apiKey: "7Cv3bAKSZWRjdcnk5chVDjwA9JB4SHEs74TMC93i",
                onTap: (data) async {
                  final controller = await _controller.future;
                  controller.addMarker(data);
                },
                initialPosition: initialPos,
                showCurrentLocation: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
