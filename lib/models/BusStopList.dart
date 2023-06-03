import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:software/models/BusStop.dart';

class BusStopList {
  static List<BusStop>? _cachedBusStops;

  static Future<List<BusStop>> getBusStops() async {
    if (_cachedBusStops != null) {
      // Return the cached list if available
      return _cachedBusStops!;
    }

    final String response =
        await rootBundle.loadString('assets/bus_stops/bus_stops_data.json');
    final jsonBusList = await json.decode(response)['value'];
    List<BusStop> busStops =
        List<BusStop>.from(jsonBusList.map((i) => BusStop.fromJson(i)));

    // Cache the list
    _cachedBusStops = busStops;

    return busStops;
  }
}
