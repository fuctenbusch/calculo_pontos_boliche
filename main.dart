import 'package:flutter/material.dart';

void main() {
  runApp(BowlingApp());
}

class BowlingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bowling Score Calculator',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: BowlingScreen(),
    );
  }
}

class BowlingScreen extends StatefulWidget {
  @override
  _BowlingScreenState createState() => _BowlingScreenState();
}

class _BowlingScreenState extends State<BowlingScreen> {
  List<int> rolls = [];
  int maxPossibleScore = 300;

  void _addRoll(int pins) {
    if (rolls.length < 20) {
      if (rolls.length % 2 == 0 && rolls.length < 18) {
        rolls.add(pins);
        if (pins == 10) {
          rolls.add(0);
        }
      } else if (rolls.length % 2 == 1 &&
          rolls.length < 18 &&
          rolls.last + pins <= 10) {
        rolls.add(pins);
      } else if (rolls.length == 18) {
        rolls.add(pins);
      } else if (rolls.length == 19 && rolls[18] == 10) {
        rolls.add(pins);
      } else if (rolls.length == 20 && rolls[18] + rolls[19] >= 10) {
        rolls.add(pins);
      }
      setState(() {});
    }
  }

  void _deleteLastRoll() {
    if (rolls.isNotEmpty) {
      setState(() {
        rolls.removeLast();
      });
    }
  }

  int _calculateScore() {
    int score = 0;
    int rollIndex = 0;

    for (int frame = 0; frame < 10 && rollIndex < rolls.length; frame++) {
      if (rolls[rollIndex] == 10) {
        // Strike
        if (rollIndex + 2 < rolls.length) {
          score += 10 + rolls[rollIndex + 1] + rolls[rollIndex + 2];
        }
        rollIndex += 1;
      } else if (rollIndex + 1 < rolls.length &&
          rolls[rollIndex] + rolls[rollIndex + 1] == 10) {
        // Spare
        if (rollIndex + 2 < rolls.length) {
          score += 10 + rolls[rollIndex + 2];
        }
        rollIndex += 2;
      } else if (rollIndex + 1 < rolls.length) {
        // Open frame
        score += rolls[rollIndex] + rolls[rollIndex + 1];
        rollIndex += 2;
      }
    }

    return score;
  }

  String _getDisplayValue(int rollIndex) {
  if (rolls.length > rollIndex) {
    if (rolls[rollIndex] == 10) {
      return 'X';
    } else if (rollIndex % 2 == 0 && rolls[rollIndex] + rolls[rollIndex + 1] == 10) {
      return '/';
    } else {
      return rolls[rollIndex].toString();
    }
  }
  return '-';
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bowling Score Calculator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 5),
            Image.asset(
              'assets/images/pistaboliche.png',
              width: 350,
              height: 350,
            ),
            Text(
              'Current Score: ${_calculateScore()}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Max Possible Score: $maxPossibleScore',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int frame = 1; frame <= 10; frame++)
                    Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.lightGreen,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Frame $frame',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            rolls.length >= (frame - 1) * 2 + 1
                                ? rolls[(frame - 1) * 2] == 10
                                    ? 'X'
                                    : rolls[(frame - 1) * 2].toString()
                                : '-',
                          ),
                          Text(
                            rolls.length >= (frame - 1) * 2 + 2
                                ? rolls[(frame - 1) * 2 + 1] == 10
                                    ? 'X'
                                    : rolls[(frame - 1) * 2 + 1].toString()
                                : '-',
                          ),
                        ],
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.lightGreen,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Frame 10',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
Text(rolls.length > 18 ? _getDisplayValue(18) : '-'),
Text(rolls.length > 19 ? _getDisplayValue(19) : '-'),
Text(rolls.length > 20 ? _getDisplayValue(20) : '-'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int pins = 0; pins <= 10; pins++)
                  ElevatedButton(
                    onPressed: () => _addRoll(pins),
                    child: Text(pins.toString()),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreen,
                    ),
                  ),
                ElevatedButton(
                  onPressed: _deleteLastRoll,
                  child: Text('Undo'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
