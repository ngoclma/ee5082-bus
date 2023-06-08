import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:software/screens/home.dart';
import 'package:software/services/theme.dart';

void main() {
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    [
      Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request().then((status) {
      runApp(const MyApp());
    });
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ('Bus Flagging Assistant'),
      theme: BusTheme().themedata,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}
