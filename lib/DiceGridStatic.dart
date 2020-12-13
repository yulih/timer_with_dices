import 'dart:ui';
import 'package:flutter/material.dart';

class DiceGridStatic extends StatelessWidget {
  DiceGridStatic(
      {Key key,
      this.listImages,
      this.dices})
      : super(key: key);

  final double dices;
  final List<String> listImages;

  @override
  Widget build(BuildContext context) {
    switch(dices.toInt()) {
      case 1:
        return Expanded(
          flex: 1,
          child: Wrap(
            spacing: 8,
            //vertical spacing
            runSpacing: 8,
            //horizontal spacing
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Image.asset(listImages?.length > 0 ? listImages[0] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
            ],
          ),
        );
      case 2:
        return Expanded(
          flex: 1,
          child: Wrap(
            spacing: 38,
            //vertical spacing
            runSpacing: 8,
            //horizontal spacing
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Image.asset(listImages?.length > 0 ? listImages[0] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[1] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
            ],
          ),
        );
      case 3:
        return Expanded(
          flex: 2,
          child: Wrap(
            spacing: 38,
            //vertical spacing
            runSpacing: 28,
            //horizontal spacing
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Image.asset(listImages?.length > 0 ? listImages[0] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[1] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[2] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
            ],
          ),
        );
      case 4:
        return Expanded(
          flex: 2,
          child: Wrap(
            spacing: 38,
            //vertical spacing
            runSpacing: 28,
            //horizontal spacing
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Image.asset(listImages?.length > 0 ? listImages[0] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[1] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[2] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[3] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
            ],
          ),
        );
      case 5:
        return Expanded(
          flex: 2,
          child: Wrap(
            spacing: 50,
            //vertical spacing
            runSpacing: 28,
            //horizontal spacing
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Image.asset(listImages?.length > 0 ? listImages[0] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[1] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[2] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[3] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[4] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
            ],
          ),
        );
      case 6:
        return Expanded(
          flex: 2,
          child: Wrap(
            spacing: 50,
            //vertical spacing
            runSpacing: 28,
            //horizontal spacing
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Image.asset(listImages?.length > 0 ? listImages[0] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[1] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[2] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[3] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[4] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
              Image.asset(listImages?.length > 0 ? listImages[5] : 'assets/images/dice1.png',
                  fit: BoxFit.cover, width: 100, height: 100),
            ],
          ),
        );
    }
  }
}
