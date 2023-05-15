import 'package:flutter/material.dart';
import 'package:software/screens/welcome.dart';
import 'package:software/screens/bus-list.dart';
import 'package:software/screens/bus-choose.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ('Bus Flagging Assistant'),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/get-eta': (context) => const BusArrivalScreen(),
        '/get-bus': (context) => const BusDropdownScreen(),
      },
    );
  }
}
