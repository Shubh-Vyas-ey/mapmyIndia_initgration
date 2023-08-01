// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CommonFunctions {
  Future<Position> getGeoLocationPosition(
      {required BuildContext context}) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      var result = await prominentDisclosure(context, 'geolocation');
      if (result) {
        permission = await Geolocator.requestPermission();
      } else {
        Navigator.pop(context);
      }
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  prominentDisclosure(context, feature) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return prominentDisclosurePopup(context, feature);
        });
    return result;
  }

  Widget prominentDisclosurePopup(context, feature) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 51, 50, 50),
      contentPadding: const EdgeInsets.all(5),
      // title: Text(""),
      content: IntrinsicHeight(
        child: Column(
          children: [
            Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 15, bottom: 5),
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: const Text(
                  'This app collects location data to enable geotag, geofence and nearby places  even when the app is closed or not in use.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 0, 25, 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        'Allow',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 0, 25, 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        'Reject',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
