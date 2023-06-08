import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:software/screens/connection.dart';
import 'package:software/services/time.dart';

class BusArrivalScreen extends StatefulWidget {
  final String? selectedBus;
  final String? startStopCode;
  final String? endStopCode;
  const BusArrivalScreen(
      {Key? key,
      @required this.selectedBus,
      @required this.startStopCode,
      @required this.endStopCode})
      : super(key: key);

  @override
  _BusArrivalScreenState createState() => _BusArrivalScreenState();
}

class _BusArrivalScreenState extends State<BusArrivalScreen> {
  final String apiUrl =
      'http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode=';
  final String apiKey = 'W7VLu7KxRJ2uzAoc36PusA==';
  List _arrivals = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    // fetch data every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'AccountKey': apiKey,
    };

    final response = await http.get(Uri.parse(apiUrl + widget.startStopCode!),
        headers: headers);

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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConnectionScreen()),
              );
            },
          ),
        ],
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
