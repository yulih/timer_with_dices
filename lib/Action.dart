import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'DiceGrid.dart';
import 'dart:math';

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
    }
    _timeTick = duration.toInt();
    _timer = new Timer.periodic(
      s,
      (Timer timer) => setState(
        () {
          if (_timeTick < 1) {
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

  // callback function
  void handleTimeout(Timer timer) {
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

  void generateDiceGrid() {
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
        onTap: () => generateDiceGrid(),
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
