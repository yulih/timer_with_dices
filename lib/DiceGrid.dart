import 'dart:ui';
import 'package:flutter/material.dart';

class DiceGrid extends StatelessWidget {
  DiceGrid(
      {Key key,
      this.listImages,
      this.color = const Color(0xFF2DBD3A),
      this.child,
      this.dices})
      : super(key: key);

  final Color color;
  final Widget child;
  final double dices;
  final List<String> listImages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: dices.toInt(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 2),
        itemBuilder: (_, dice_index) {
              return Image.asset(listImages[dice_index],
                  fit: BoxFit.cover, width: 100, height: 100);
          } //Image.asset(listImages[index], fit: BoxFit.cover, width: 100, height: 100);
      ),
    );
  }
}
