import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BuzzerControlPage extends StatefulWidget {
  @override
  _BuzzerControlPageState createState() => _BuzzerControlPageState();
}

class _BuzzerControlPageState extends State<BuzzerControlPage> {
  BluetoothDevice? device;
  BluetoothCharacteristic? characteristic;
  bool isBuzzerOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buzzer Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Connect to Buzzer'),
              onPressed: () async {
                // Connect to the Buzzer device using Bluetooth
                FlutterBlue flutterBlue = FlutterBlue.instance;
                List<BluetoothDevice> devices =
                    await flutterBlue.connectedDevices;
                if (devices.isNotEmpty) {
                  setState(() {
                    device = devices.first;
                  });
                  List<BluetoothService> services =
                      await device!.discoverServices();
                  services.forEach((service) {
                    service.characteristics.forEach((characteristic) {
                      if (characteristic.uuid
                          .toString()
                          .toUpperCase()
                          .contains('YOUR_CHARACTERISTIC_UUID')) {
                        setState(() {
                          this.characteristic = characteristic;
                        });
                        // Read the initial value of the characteristic
                        characteristic.read().then((value) {
                          setState(() {
                            isBuzzerOn = (value.first == 1);
                          });
                        });
                      }
                    });
                  });
                }
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text(isBuzzerOn ? 'Turn Off Buzzer' : 'Turn On Buzzer'),
              onPressed: () {
                // Send command to turn the Buzzer on or off
                if (characteristic != null) {
                  // Toggle the Buzzer state
                  isBuzzerOn = !isBuzzerOn;
                  // Send the command to the Buzzer
                  characteristic!.write([isBuzzerOn ? 1 : 0]);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
