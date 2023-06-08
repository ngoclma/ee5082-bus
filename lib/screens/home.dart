import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:software/screens/arrival.dart';
import 'package:software/screens/connection.dart';
import 'package:software/models/BusStop.dart';
import 'package:software/services/bus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BusStop? detectedStop;

  String? selectedBus;
  String? startStop;
  String? endStop;

  final TextEditingController _typeAheadControllerStartStop =
      TextEditingController();
  final TextEditingController _typeAheadControllerEndStop =
      TextEditingController();
  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  @override
  void initState() {
    super.initState();
    _fetchDetectedStop();
  }

  Future<void> _fetchDetectedStop() async {
    BusStop nearestStop = await getNearestBusStop();
    setState(() {
      detectedStop = nearestStop;
      _typeAheadControllerStartStop.text =
          '${detectedStop!.busStopCode} ${detectedStop!.description}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Eye'),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Where are you going?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 32.0),
              Text(
                'You are at:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.yellow.shade400,
                ),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  child: TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.my_location),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      autofocus: true,
                      cursorColor: Colors.black,
                      controller: _typeAheadControllerStartStop,
                      textAlignVertical: TextAlignVertical.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    suggestionsCallback: (pattern) {
                      return getSuggestions(pattern);
                    },
                    itemBuilder: (context, String suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    itemSeparatorBuilder: (context, index) {
                      return const Divider();
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    onSuggestionSelected: (String suggestion) {
                      _typeAheadControllerStartStop.text = suggestion;
                    },
                    suggestionsBoxController: suggestionBoxController,
                    validator: (value) =>
                        value!.isEmpty ? 'Please select a bus stop' : null,
                    onSaved: (value) => startStop = value,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'You are heading to:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.yellow.shade400,
                ),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  child: TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.location_on),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      autofocus: true,
                      cursorColor: Colors.black,
                      controller: _typeAheadControllerEndStop,
                      textAlignVertical: TextAlignVertical.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    suggestionsCallback: (pattern) {
                      return getSuggestions(pattern);
                    },
                    itemBuilder: (context, String suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    itemSeparatorBuilder: (context, index) {
                      return const Divider();
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    onSuggestionSelected: (String suggestion) {
                      _typeAheadControllerEndStop.text = suggestion;
                    },
                    suggestionsBoxController: suggestionBoxController,
                    validator: (value) =>
                        value!.isEmpty ? 'Please select a bus stop' : null,
                    onSaved: (value) => startStop = value,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 300.0,
                height: 140.0,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BusArrivalScreen(
                              selectedBus: selectedBus,
                              startStopCode: _typeAheadControllerStartStop.text
                                  .toString()
                                  .split(" ")[0],
                              endStopCode: _typeAheadControllerEndStop.text
                                  .toString()
                                  .split(" ")[0])),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.yellow.shade500),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.departure_board,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        'Track Bus',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
