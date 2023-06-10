import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:software/services/time.dart';

class BluetoothUtils {
  // Private constructor
  BluetoothUtils._privateConstructor();

  // Singleton instance
  static final BluetoothUtils _instance = BluetoothUtils._privateConstructor();

  // Factory constructor to return the instance
  factory BluetoothUtils() {
    return _instance;
  }

  // Initializing the Bluetooth connection state to be unknown
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;

  // Get the instance of the Bluetooth
  final FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection? connection;

  // Bluetooth variables
  final List<BluetoothDevice> devicesList = [];
  BluetoothDevice? device;
  bool connected = false;
  int deviceState = 0;
  bool isDisconnecting = false;
  bool isButtonUnavailable = false;

  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Colors.green.shade700,
    'offTextColor': Colors.red.shade700,
    'neutralTextColor': Colors.blue,
  };

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection?.isConnected ?? false;

  String receiveBusNo() {
    String receivedString = '';
    connection?.input?.listen((Uint8List data) {
      receivedString = String.fromCharCodes(data);
    });
    print(receivedString);
    return receivedString;
  }

  void sendArrivalStatus(String busNo, List arrivals) async {
    int dvstate = 0;
    for (dynamic arrival in arrivals) {
      print(arrival['ServiceNo']);
      print(getDifference(arrival['NextBus']['EstimatedArrival']));
      if ((arrival['ServiceNo'] == busNo) &&
          (getDifference(arrival['NextBus']['EstimatedArrival']) <= 1)) {
        dvstate = 1;
        print(dvstate);
        break;
      }
    }
    connection?.output.add(utf8.encoder.convert(dvstate.toString()));
    await connection?.output.allSent;
  }

  // Request Bluetooth permission from the user
  Future<bool> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    }

    await getPairedDevices();
    return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<List<BluetoothDevice>> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await bluetooth.getBondedDevices();
      print(devices);
    } on PlatformException catch (e) {
      print("Error in PairedDevice");
      print(e);
    }

    return devices;
  }

  // Method to connect to bluetooth
  void connect() async {
    isButtonUnavailable = true;
    if (device == null) {
      print('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(device?.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;
          connected = true;

          connection!.input!.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        print('Device connected');

        isButtonUnavailable = false;
      }
    }
  }

  void onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }
  }

  // Method to disconnect bluetooth
  void disconnect() async {
    isButtonUnavailable = true;
    deviceState = 0;

    await connection!.close();
    print('Device disconnected');
    if (!connection!.isConnected) {
      connected = false;
      isButtonUnavailable = false;
    }
  }

  // Method to send message,
  // for turning the Bluetooth device on
  void sendOnMessageToBluetooth() async {
    connection!.output.add(utf8.encoder.convert('1' + '\r\n'));
    await connection!.output.allSent;
    print('Device Turned On');
    deviceState = 1; // device on
  }

  // Method to send message,
  // for turning the Bluetooth device off
  void sendOffMessageToBluetooth() async {
    connection!.output.add(utf8.encoder.convert("0" + "\r\n"));
    await connection!.output.allSent;
    print('Device Turned Off');
    deviceState = -1; // device off
  }
}
