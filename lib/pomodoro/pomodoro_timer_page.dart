import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

int initialMinutes = 04;
int initialSeconds = 59;
String time = '05:00';
var duration = const Duration(seconds: 1);
var watch = Stopwatch();
FlutterSound flutterSound = new FlutterSound();

class PomodoroTimer extends StatefulWidget {
  @override
  PomodoroTimerState createState() => PomodoroTimerState();
}

class PomodoroTimerState extends State<PomodoroTimer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
      ),
      body: _buildPomodoroTimer(),
    );
  }

  void _startStopwatch() {
    if (_isPlaying()) {
      watch.stop();
    } else {
      watch.start();
      _startTimer();
    }
  }

  void _restart() {
    watch.stop();
    watch.reset();
    setState(() {
      time = '05:00';
    });
  }

  bool _isPlaying() {
    return watch.isRunning;
  }

  Widget _buildPomodoroTimer() {
    return Center(
        child: Column(
      children: <Widget>[
        stopwatch(),
        Expanded(
          flex: 1,
          child: Icon(
            IcoFontIcons.tomato,
            size: 200.00,
            color: Colors.red[900],
          ),
        ),
        Row(children: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _restart,
            iconSize: 60,
            color: Colors.red,
          ),
          IconButton(
            icon: _isPlaying() ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            onPressed: _startStopwatch,
            iconSize: 60,
            color: Colors.green[700],
          )
        ], mainAxisAlignment: MainAxisAlignment.center),
      ],
    ));
  }

  void _startTimer() {
    Timer(duration, _keepRunning);
  }

  void _keepRunning() {
    if (watch.isRunning) {
      _startTimer();
    }

    setState(() {
      int currentMinute = int.parse(watch.elapsed.inMinutes.toString());
      int currentSeconds = int.parse((watch.elapsed.inSeconds % 60).toString());
      int timerMinutes = initialMinutes - currentMinute;
      int timerSeconds = initialSeconds - currentSeconds;

      if (timerSeconds < 60 && timerSeconds >= 0) {
        time = timerMinutes.toString().padLeft(2, '0') +
            ':' +
            timerSeconds.toString().padLeft(2, '0');

        if (time == '00:00') {
          _playSong();
        }
      }
      if (timerMinutes < 0) {
        time = '00:00';
        watch.stop();
      }
    });
  }

  void _playSong() async {
    await flutterSound.startPlayer(
        'https://sounds-mp3.com/mp3/0003282.mp3');
    _setTimeoutForSong(10000);
  }

  void _setTimeoutForSong([int milliseconds]) {
    const timeout = const Duration(seconds: 10);
    const ms = const Duration(milliseconds: 1);
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    Timer(duration, _stopSong);
  }

  void _stopSong() {
    flutterSound.stopPlayer();
  }
}

Widget stopwatch() {
  return Container(
    margin: EdgeInsets.only(top: 50.0),
    child: Text(
      time,
      style: TextStyle(fontSize: 50),
    ),
  );
}
