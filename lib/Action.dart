import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'DiceGrid.dart';
import 'dart:math';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audio_cache.dart';

class ActionRoute extends StatefulWidget {
  ActionRoute({Key key, this.title, double this.timer, double this.dices}) : super(key: key);

  final String title;
  final double timer;
  final double dices;

  @override
  _ActionRoute createState() => _ActionRoute();
}

class _ActionRoute extends State<ActionRoute> {
  Timer _timer;
  Timer _timerAnimation;
  int _timeTick;
  List<String> _listImages = [];

  static const s = const Duration(seconds: 1);
  static const ms = const Duration(milliseconds: 1);

  startTimeout(num duration) {
    if (_timer != null) {
      _timer.cancel();
      Vibration.cancel();
    }
    _timeTick = duration.toInt();
    _timer = new Timer.periodic(
      s,
      (Timer timer) => setState(
        () {
          if (_timeTick < 2) {
            handleTimeout(timer);
          } else {
            _timeTick = _timeTick - 1;
          }
        },
      ),
    );
  }

  diceRollAnimation() {
    if (_timerAnimation != null) {
      _timerAnimation.cancel();
    }
    _timerAnimation = new Timer.periodic(
      ms * 100, //interval
      (Timer timer) => setState(
        () {
          setState(() {
            _listImages.clear();
            var rng = new Random();
            for (var i = 1; i <= widget.dices; i++) {
              var num = rng.nextInt(5) + 1;
              _listImages.add('assets/images/dice$num.png');
            }
          });
        },
      ),
    );
  }
  //
  // callback function
  handleTimeout(Timer timer) async {
    _timeTick = 0;
    AudioCache player = new AudioCache();
    const alarmAudioPath = "0073.wav";
    player.play(alarmAudioPath);
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 1200, amplitude: 128);
/*    Vibration.vibrate(
      pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
      intensities: [128, 255, 64, 255],
    );*/
    }
    timer.cancel();
  }

  @override
  void dispose() {
    _timer.cancel();
    _timerAnimation.cancel();
    super.dispose();
  }

  @override
  void initState() {
    generateDiceGrid();
    super.initState();
  }

  Future<void> generateDiceGrid() async {
    if (await Vibration.hasVibrator()) {
    Vibration.vibrate(duration: 500, amplitude: 128);
    }
    _timeTick = widget.timer.toInt();
    diceRollAnimation();
    Timer(Duration(milliseconds: 700), () {
      _timerAnimation.cancel();
    });
    startTimeout(widget.timer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer (Tap screen to start!)"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.heavyImpact();
          generateDiceGrid();
          },
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [Colors.orangeAccent, Colors.red])),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Center(
                      child: Text('$_timeTick',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white54)),
                    )),
                Expanded(
                  flex: 2,
                  child: DiceGrid(
                    color: Colors.green,
                    dices: widget.dices,
                    listImages: _listImages,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
