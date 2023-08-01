import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mappls_place_widget/mappls_place_widget.dart';

import 'common_function.dart';
import 'map.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: add the api keys here  wich aleady shared with you

    super.initState();
  }

  ReverseGeocodePlace _place = ReverseGeocodePlace();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map My india"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Align(
      alignment: Alignment.topCenter,
      child: ListView(
        children: [
          widgets(
              title: "Show Map & get Lat Long (On Tap)",
              onTap: () async {
                Position postions = await CommonFunctions()
                    .getGeoLocationPosition(context: context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapView(
                        latitude: postions.latitude,
                        longitude: postions.longitude,
                      ),
                    ));
              }),
          widgets(
              title: "getaddress",
              onTap: () {
                openMapplsPlacePickerWidget();
              }),
          widgets(title: "get all address (on Tap)", onTap: () {}),
          //   widgets(title: "Show Map", onTap: () {}),
        ],
      ),
    );
  }

  openMapplsPlacePickerWidget() async {
    ReverseGeocodePlace place;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      place = await openPlacePicker(PickerOption(
        includeDeviceLocationButton: true,
      ));

      if (kDebugMode) {
        print(json.encode(place.toJson()));
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      setState(() {
        _place = place;
      });
    } catch (r) {
      if (kDebugMode) {
        print("error here $r");
      }
    }
  }

  da() {}

  Widget widgets({required String title, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Center(
          child: Card(
              child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title),
      ))),
    );
  }
}
