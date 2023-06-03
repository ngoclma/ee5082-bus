import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:software/models/BusStop.dart';
import 'package:software/services/time.dart';

class BusArrivalScreen extends StatefulWidget {
  final String? selectedBus;
  final BusStop? selectedStop;
  const BusArrivalScreen(
      {Key? key, @required this.selectedBus, @required this.selectedStop})
      : super(key: key);

  @override
  _BusArrivalScreenState createState() => _BusArrivalScreenState();
}

class _BusArrivalScreenState extends State<BusArrivalScreen> {
  final String apiUrl =
      'http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode=';
  final String apiKey = 'W7VLu7KxRJ2uzAoc36PusA==';
  List _arrivals = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'AccountKey': apiKey,
    };

    String? busStopCode = widget.selectedStop?.busStopCode;
    final response =
        await http.get(Uri.parse(apiUrl + busStopCode!), headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        _arrivals = json['Services'];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Arrival Times'),
      ),
      body: ListView.builder(
        itemCount: _arrivals.length,
        itemBuilder: (context, index) {
          final arrival = _arrivals[index];
          return ListTile(
            title: Text('Bus ${arrival['ServiceNo']}'),
            subtitle: Text(
                'Arriving in ${timeDisplay(getDifference(arrival['NextBus']['EstimatedArrival']))}'),
          );
        },
      ),
    );
  }
}
