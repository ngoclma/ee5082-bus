import 'package:flutter/material.dart';
import 'package:software/screens/bus-list.dart';
import 'package:software/models/BusStop.dart';

class BusDropdownScreen extends StatefulWidget {
  final BusStop? selectedStop;
  const BusDropdownScreen({Key? key, @required this.selectedStop})
      : super(key: key);

  @override
  _BusDropdownScreenState createState() => _BusDropdownScreenState();
}

class _BusDropdownScreenState extends State<BusDropdownScreen> {
  String? selectedBus;

  final busNumbers = [
    '2',
    '2A',
    '3',
    '3A',
    '4',
    '5',
    '6',
    '7',
    '7A',
    '7B',
    '8',
    '9',
    '9A',
    '10',
    '10e',
    '11',
    '12',
    '12e',
    '13',
    '13A',
    '14',
    '14A',
    '14e',
    '15',
    '15A',
    '16',
    '16M',
    '17',
    '17A',
    '18',
    '19',
    '20',
    '21',
    '21A',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '27A',
    '28',
    '29',
    '29A',
    '30',
    '30e',
    '31',
    '31A',
    '32',
    '33',
    '33A',
    '33B',
    '34',
    '34A',
    '34B',
    '35',
    '35M',
    '36/36T',
    '36A',
    '36B',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '43e',
    '43M',
    '45',
    '45A',
    '46',
    '47',
    '48',
    '49',
    '50',
    '51',
    '51A',
    '52',
    '53',
    '53A',
    '53M',
    '54',
    '55',
    '55B',
    '56',
    '57',
    '58',
    '58A',
    '58B',
    '59',
    '60',
    '60A',
    '61',
    '62',
    '62A',
    '63',
    '63A',
    '63M',
    '64',
    '65',
    '66',
    '67',
    '68',
    '68A',
    '68B',
    '69',
    '70',
    '70A',
    '70B',
    '70M',
    '71',
    '72',
    '72A',
    '72B',
    '73',
    '74',
    '75',
    '76',
    '77',
    '78',
    '78A',
    '79',
    '79A',
    '80',
    '80A',
    '81',
    '82',
    '83',
    '84',
    '85',
    '85A',
    '86',
    '87',
    '88',
    '88A',
    '88B',
    '89',
    '89A',
    '89e',
    '90',
    '90A',
    '91',
    '92',
    '92A',
    '92B',
    '92M',
    '93',
    '94',
    '94A',
    '95',
    '95B',
    '96',
    '96A',
    '96B',
    '97',
    '97e',
    '98',
    '98A',
    '98B',
    '98M',
    '99',
    '100',
    '100A',
    '101',
    '102',
    '102A',
    '103',
    '105',
    '105B',
    '106',
    '106A',
    '107',
    '107M',
    '109',
    '109A',
    '110',
    '111',
    '112',
    '112A',
    '113',
    '113A',
    '114',
    '114A',
    '115',
    '116',
    '116A',
    '117',
    '117A',
    '117M',
    '118',
    '118A',
    '118B',
    '119',
    '120',
    '121',
    '122',
    '123',
    '123M',
    '124',
    '125',
    '125A',
    '127',
    '127A',
    '129',
    '130',
    '130A',
    '131',
    '131A',
    '132',
    '133',
    '134',
    '135',
    '136',
    '137',
    '137A',
    '138',
    '138A',
    '138B',
    '139',
    '139A',
    '140',
    '141',
    '142',
    '142A',
    '143',
    '143M',
    '145',
    '145A',
    '147',
    '147A',
    '150',
    '151',
    '153',
    '154',
    '154A',
    '154B',
    '155',
    '156',
    '157',
    '158',
    '158A',
    '159',
    '159A',
    '159B',
    '160',
    '160A',
    '160M',
    '161',
    '162',
    '162M',
    '163',
    '163A',
    '165',
    '166',
    '167',
    '168',
    '169',
    '169A',
    '169B',
    '170',
    '170X',
    '171',
    '172',
    '173',
    '173A',
    '174',
    '174e',
    '175',
    '176',
    '177',
    '178',
    '178A',
    '179',
    '179A',
    '',
    '180',
    '180A',
    '181',
    '181M',
    '182',
    '182M',
    '183',
    '183B',
    '184',
    '185',
    '186',
    '187',
    '188',
    '188e',
    '189',
    '189A',
    '190',
    '190A',
    '191',
    '192',
    '193',
    '194',
    '195',
    '195A',
    '196',
    '196A',
    '196e',
    '197',
    '198',
    '198A',
    '199',
    '200',
    '200A',
    '201',
    '222',
    '222A',
    '222B',
    '225',
    '228',
    '229',
    '231',
    '232',
    '235',
    '238',
    '240',
    '240A',
    '240M',
    '241',
    '241A',
    '242',
    '243',
    '246',
    '247',
    '248',
    '248M',
    '249',
    '251',
    '252',
    '253',
    '254',
    '255',
    '257',
    '258',
    '261',
    '262',
    '265',
    '268',
    '268A',
    '268B',
    '268C',
    '269',
    '269A',
    '272',
    '273',
    '282',
    '284',
    '285',
    '291/291T',
    '292',
    '293/293T',
    '298',
    '300',
    '301',
    '302',
    '302A',
    '307/307T',
    '307A',
    '315',
    '317',
    '324',
    '325',
    '329',
    '333',
    '334',
    '335',
    '354',
    '358',
    '359',
    '371',
    '372',
    '374',
    '381',
    '382G',
    '382W',
    '382A',
    '384',
    '386',
    '386A',
    '400',
    '401',
    '403',
    '405',
    '410G',
    '410G',
    '502',
    '502A',
    '506',
    '513',
    '518',
    '518A',
    '651',
    '652',
    '653',
    '654',
    '655',
    '656',
    '657',
    '660',
    '661',
    '663',
    '665',
    '666',
    '667',
    '668',
    '670',
    '671',
    '672',
    '800',
    '801',
    '803',
    '804',
    '805',
    '806',
    '807',
    '807A',
    '807B',
    '811',
    '811T',
    '811A',
    '812',
    '812T',
    '825',
    '850E',
    '851',
    '851e',
    '852',
    '853',
    '853M',
    '854',
    '854e',
    '855',
    '856',
    '857',
    '857A',
    '857B',
    '858',
    '858A',
    '858B',
    '859',
    '859A',
    '859B',
    '860',
    '868E',
    '882',
    '882A',
    '883',
    '883B',
    '883M',
    '900',
    '900A',
    '901',
    '901M',
    '902',
    '903',
    '903M',
    '904',
    '911',
    '911T',
    '912',
    '912A',
    '912B',
    '912M',
    '913',
    '913T',
    '913M',
    '920',
    '922',
    '925',
    '925A',
    '925M',
    '927',
    '941',
    '944',
    '945',
    '947',
    '950',
    '951E',
    '960',
    '960e',
    '961',
    '961M',
    '962',
    '962B',
    '962C',
    '963',
    '963e',
    '964',
    '965',
    '965A',
    '966',
    '966A',
    '969',
    '969A',
    '970',
    '972',
    '972A',
    '972M',
    '973',
    '973A',
    '974',
    '974A',
    '975',
    '975A',
    '975B',
    '975C',
    '976',
    '979',
    '980',
    '981',
    '982E',
    '983',
    '983A',
    '985',
    '990',
    '991',
    '991A',
    '991B',
    '991C'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Query'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You are at ${widget.selectedStop?.description}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select a Bus',
              ),
              value: selectedBus,
              items: busNumbers.map((bus) {
                return DropdownMenuItem(
                  value: bus,
                  child: Text(bus),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBus = value as String;
                });
              },
              onSaved: (value) {
                setState(() {
                  selectedBus = value as String;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BusArrivalScreen(
                          selectedBus: selectedBus,
                          selectedStop: widget.selectedStop)),
                );
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            // IconButton(
            //   onPressed: () {
            //     // Microphone button pressed
            //   },
            //   icon: Icon(Icons.mic),
            // ),
          ],
        ),
      ),
    );
  }
}
