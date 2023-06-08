import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';

stt.SpeechToText _speechToText = stt.SpeechToText();
bool _speechEnabled = false;

// void _initSpeech() async {
//   _speechEnabled = await _speechToText.initialize();
//   setState(() {});
// }

// void _startListening() async {
//   await _speechToText.listen(onResult: _onSpeechResult);
//   setState(() {});
// }

// void _stopListening() async {
//   await _speechToText.stop();
//   setState(() {});
// }

// void _onSpeechResult(SpeechRecognitionResult result) {
//   setState(() {
//     _typeAheadControllerEndStop.text = result.recognizedWords;
//   });
// }

            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     _speechToText.isNotListening ? _startListening : _stopListening;
            //   },
            //   child: const Icon(Icons.mic),
            // ),
