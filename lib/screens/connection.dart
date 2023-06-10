import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:software/services/bluetooth.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({Key? key}) : super(key: key);

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  BluetoothUtils bluetoothUtils = BluetoothUtils();

  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        bluetoothUtils.bluetoothState = state;
      });
    });

    bluetoothUtils.deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    bluetoothUtils.enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        bluetoothUtils.bluetoothState = state;
        if (bluetoothUtils.bluetoothState == BluetoothState.STATE_OFF) {
          bluetoothUtils.isButtonUnavailable = true;
        }
        bluetoothUtils.getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (bluetoothUtils.isConnected) {
      bluetoothUtils.isDisconnecting = true;
      bluetoothUtils.connection?.dispose();
      bluetoothUtils.connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("Connect to device"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.all(5),
              child: TextButton.icon(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                label: const Text(
                  "Refresh",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.white70))),
                ),
                onPressed: () async {
                  await bluetoothUtils.getPairedDevices().then((_) {
                    show('Device list refreshed');
                  });
                },
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Visibility(
              visible: bluetoothUtils.isButtonUnavailable &&
                  bluetoothUtils.bluetoothState == BluetoothState.STATE_ON,
              child: const LinearProgressIndicator(
                backgroundColor: Colors.yellow,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Enable Bluetooth',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Switch(
                    value: bluetoothUtils.bluetoothState.isEnabled,
                    onChanged: (bool value) {
                      future() async {
                        if (value) {
                          await FlutterBluetoothSerial.instance.requestEnable();
                        } else {
                          await FlutterBluetoothSerial.instance
                              .requestDisable();
                        }

                        await bluetoothUtils.getPairedDevices();
                        bluetoothUtils.isButtonUnavailable = false;

                        if (bluetoothUtils.connected) {
                          bluetoothUtils.disconnect();
                        }
                      }

                      future().then((_) {
                        setState(() {});
                      });
                    },
                  )
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "PAIRED DEVICES",
                        style: TextStyle(fontSize: 24, color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Device:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownButton(
                            items: _getDeviceItems(),
                            onChanged: (value) => setState(() => bluetoothUtils
                                .device = value as BluetoothDevice?),
                            value: bluetoothUtils.devicesList.isNotEmpty
                                ? bluetoothUtils.device
                                : null,
                          ),
                          ElevatedButton(
                            onPressed: bluetoothUtils.isButtonUnavailable
                                ? null
                                : bluetoothUtils.connected
                                    ? bluetoothUtils.disconnect
                                    : bluetoothUtils.connect,
                            child: Text(bluetoothUtils.connected
                                ? 'Disconnect'
                                : 'Connect'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: bluetoothUtils.deviceState == 0
                                ? bluetoothUtils.colors['neutralBorderColor']
                                    as Color
                                : bluetoothUtils.deviceState == 1
                                    ? bluetoothUtils.colors['onBorderColor']
                                        as Color
                                    : bluetoothUtils.colors['offBorderColor']
                                        as Color,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        elevation: bluetoothUtils.deviceState == 0 ? 4 : 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "DEVICE 1",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: bluetoothUtils.deviceState == 0
                                        ? bluetoothUtils
                                            .colors['neutralTextColor']
                                        : bluetoothUtils.deviceState == 1
                                            ? bluetoothUtils
                                                .colors['onTextColor']
                                            : bluetoothUtils
                                                .colors['offTextColor'],
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: bluetoothUtils.connected
                                    ? bluetoothUtils.sendOnMessageToBluetooth
                                    : null,
                                child: const Text("ON"),
                              ),
                              TextButton(
                                onPressed: bluetoothUtils.connected
                                    ? bluetoothUtils.sendOffMessageToBluetooth
                                    : null,
                                child: const Text("OFF"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.red,
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "NOTE: If you cannot find the device in the list, please pair the device by going to the bluetooth settings",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        child: const Text("Bluetooth Settings"),
                        onPressed: () {
                          FlutterBluetoothSerial.instance.openSettings();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (bluetoothUtils.devicesList.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      for (var device in bluetoothUtils.devicesList) {
        items.add(DropdownMenuItem(
          value: device,
          child: Text(device.name!),
        ));
      }
    }
    return items;
  }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
