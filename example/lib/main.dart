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
  double _currentZoom = 15.0;

  @override
  void initState() {
    super.initState();
    setInitialPos();
  }

  void setInitialPos() async {
    await Geolocator.requestPermission();
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      initialPos =
          LatLng(latitude: position.latitude, longitude: position.longitude);
    });
  }

  Future<void> _zoomIn() async {
    final controller = await _controller.future;
    _currentZoom += 1;
    controller.setZoom(_currentZoom);
  }

  Future<void> _zoomOut() async {
    final controller = await _controller.future;
    _currentZoom -= 1;
    controller.setZoom(_currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: Scaffold(
        body: Stack(
          children: [
            Column(
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
            Positioned(
              bottom: 80,
              right: 10,
              child: Column(
                children: [
                  FloatingActionButton(
                    onPressed: _zoomIn,
                    mini: true,
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: _zoomOut,
                    mini: true,
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
