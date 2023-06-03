import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:software/models/BusStop.dart';
import 'package:software/models/BusStopList.dart';

// Future<List<BusStop>> getBusStops() async {
//   final String response =
//       await rootBundle.loadString('assets/bus_stops/bus_stops_data.json');
//   final jsonBusList = await json.decode(response)['value'];
//   List<BusStop> busStops =
//       List<BusStop>.from(jsonBusList.map((i) => BusStop.fromJson(i)));

//   return busStops;
// }

Future<BusStop> getNearestBusStop() async {
  List<BusStop> busStops = await BusStopList.getBusStops();
  Position userPosition = await _determinePosition();
  BusStop selectedStop = findNearestBusStop(userPosition, busStops);

  return selectedStop;
}

Future<List<String>> getSuggestions(String query) async {
  List<BusStop> busStops = await BusStopList.getBusStops();
  List<String> busStopStrings = busStops.map((busStop) {
    return '${busStop.busStopCode} ${busStop.description}';
  }).toList();
  List<String> matches = <String>[];
  matches.addAll(busStopStrings);

  matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
  return matches;
}

/*
  Get User's position
*/
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled
    return Future.error('Location services are disabled.');
  }

  // Check for location permission
  await Geolocator.requestPermission();
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // Location permissions are denied
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Location permissions are still denied
      return Future.error('Location permissions are denied.');
    }
  }

  // Return the user's current location
  return await Geolocator.getCurrentPosition();
}

/*
  Find the nearest BusStop
*/
BusStop findNearestBusStop(Position userLocation, List<BusStop> busStops) {
  double minDistance = double.infinity;
  BusStop nearestBusStop = busStops.first;
  int i = 1;
  for (BusStop busStop in busStops) {
    // double distance = getDistance(userLocation, busStop);
    double distance = Geolocator.distanceBetween(userLocation.latitude,
        userLocation.longitude, busStop.latitude, busStop.longitude);
    if (distance < minDistance) {
      minDistance = distance;
      nearestBusStop = busStop;
    }
  }
  return nearestBusStop;
}
