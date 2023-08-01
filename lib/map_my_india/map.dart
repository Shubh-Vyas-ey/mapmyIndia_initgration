import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mappls_gl/mappls_gl.dart';

class MapView extends StatefulWidget {
  MapView({super.key, required this.latitude, required this.longitude});
  double latitude;
  double longitude;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late MapplsMapController mapController;
  LatLng? currentLatLong;
  late Symbol marker;
  @override
  void initState() {
    super.initState();
  }

  addMarker() async {
    try {
      marker = await mapController.addSymbol(SymbolOptions(
          geometry: (currentLatLong != null)
              ? currentLatLong
              : LatLng(widget.latitude, widget.longitude)));
    } catch (e) {
      if (kDebugMode) {
        print("marker error $e");
      }
    }
  }

  removeMarker() async {
    await mapController.removeSymbol(marker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapplsMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 14.0,
        ),
        annotationOrder: const [
          AnnotationType.symbol,
        ],
        onMapCreated: (map) => {mapController = map, addMarker()},

        onMapClick: (point, latlng) =>

            // ignore: avoid_print
            {
          currentLatLong = latlng,
          setState(() {}),
          removeMarker(),
          addMarker(),
          // print("current lat long ${latlng.toString()}")
        },
        // annotationConsumeTapEvents: const [AnnotationType.symbol],
      ),
    );
  }
}
