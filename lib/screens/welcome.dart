import 'package:flutter/material.dart';
import 'package:software/screens/stops_choosing.dart';
import 'package:software/screens/connection.dart';
import 'package:software/services/bus.dart';
import 'package:software/models/BusStop.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to BUSEYE',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Bus Flagging Assistant',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 200.0,
              height: 200.0,
              child: ElevatedButton(
                onPressed: () async {
                  BusStop nearestStop = await getNearestBusStop();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BusDropdownScreen()),
                  );
                },
                child: const Text(
                  'Start trip',
                  style: TextStyle(
                    fontSize: 28.0, // Adjust the font size
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
