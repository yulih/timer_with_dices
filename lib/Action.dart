import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:timer_with_dices/DiceGridStatic.dart';
import 'package:timer_with_dices/models/ThemeEnum.dart';
import 'DiceGrid.dart';
import 'dart:math';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:wakelock/wakelock.dart';

class ActionRoute extends StatefulWidget {
  ActionRoute(
      {Key key,
      this.title,
      double this.timer,
      double this.dices,
      ThemeEnum this.globalTheme})
      : super(key: key);

  final String title;
  final double timer;
  final double dices;
  final ThemeEnum globalTheme;

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

  AudioCache _audioCache;
  //String url_start = "0014.wav";
  String url_start = "00dice.mp3";

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
              var num = rng.nextInt(6) + 1;
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
      Vibration.vibrate(duration: 800, amplitude: 128);
/*    Vibration.vibrate(
      pattern: [500, 1000, 500, 2000, 500, 3000, 500, 500],
      intensities: [128, 255, 64, 255],
    );*/
    }
    timer.cancel();
  }

  @override
  void dispose() {
    // The next line disables the wakelock again.
    Wakelock.disable();
    _timer.cancel();
    _timerAnimation.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // The following line will enable the Android and iOS wakelock.
    Wakelock.enable();
    generateDiceGrid();
    //AudioPlayer.logEnabled = true;
    _audioCache = AudioCache(prefix: "assets/", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
    _audioCache.play(url_start);
    super.initState();
  }

  List<Color> getColorGradient(ThemeEnum theme) {
    switch (theme) {
      case ThemeEnum.orange:
        return [Colors.orangeAccent, Colors.red];
      case ThemeEnum.black:
        return [Colors.black, Colors.black];
      case ThemeEnum.community:
        return [Color(0xff543864), Color(0xff202040)];
    }
  }

  Future<void> generateDiceGrid() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 300, amplitude: 128);
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
        title: Text("Timer - Tap to start!"),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _audioCache.play(url_start);
          generateDiceGrid();
        },
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: getColorGradient(widget.globalTheme))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Center(
                      child: Text('$_timeTick',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              color: Colors.white54)),
                    )),
                DiceGridStatic(dices: widget.dices, listImages: _listImages,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
