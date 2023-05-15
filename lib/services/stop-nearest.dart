import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' show asin, atan2, cos, pi, pow, sin, sqrt;
import 'package:geolocator/geolocator.dart';
import 'package:software/models/BusStop.dart';

Future<BusStop> getNearestBusStop() async {
  String apiUrl = 'http://datamall2.mytransport.sg/ltaodataservice/BusStops';
  String apiKey = 'W7VLu7KxRJ2uzAoc36PusA==';

  Map<String, String> headers = {
    'accept': 'application/json',
    'AccountKey': apiKey,
  };

  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body)['value'];

      List<BusStop> busStops =
          List<BusStop>.from(jsonList.map((i) => BusStop.fromJson(i)));

      // User position
      Position userPosition = await _determinePosition();
      print(userPosition);

      BusStop selectedStop = findNearestBusStop(userPosition, busStops);

      return selectedStop;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return BusStop(
          busStopCode: "01012",
          roadName: "magic road",
          description: "Find bug please",
          latitude: 1.29684825487647,
          longitude: 103.85253591654006);
    }
  } catch (e) {
    print(e);
    return BusStop(
        busStopCode: "01012",
        roadName: "magic road",
        description: "Find bug please",
        latitude: 1.29684825487647,
        longitude: 103.85253591654006);
  }
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
  Get Distance between userLoc and a busStop
*/
double getDistance(Position userLocation, BusStop busStop) {
  const double earthRadius = 6371; // in kilometers
  double lat1 = userLocation.latitude * pi / 180.0;
  double lon1 = userLocation.longitude * pi / 180.0;
  double lat2 = busStop.latitude * pi / 180.0;
  double lon2 = busStop.longitude * pi / 180.0;
  double dlat = lat2 - lat1;
  double dlon = lon2 - lon1;
  double a =
      pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c;
  return distance;
}

/*
  Find the nearest BusStop
*/
BusStop findNearestBusStop(Position userLocation, List<BusStop> busStops) {
  double minDistance = double.infinity;
  BusStop nearestBusStop = busStops.first;
  for (BusStop busStop in busStops) {
    double distance = getDistance(userLocation, busStop);
    if (distance < minDistance) {
      minDistance = distance;
      nearestBusStop = busStop;
    }
  }
  return nearestBusStop;
}
