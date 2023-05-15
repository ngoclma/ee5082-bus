import 'package:flutter/material.dart';
import 'package:software/screens/bus-choose.dart';
import 'package:software/services/stop-nearest.dart';
import 'package:software/models/BusStop.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bus Flagging Assistant',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                BusStop nearestStop = await getNearestBusStop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BusDropdownScreen(selectedStop: nearestStop)),
                );
              },
              child: Text('Start journey'),
            ),
          ],
        ),
      ),
    );
  }
}
