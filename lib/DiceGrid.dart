import 'dart:ui';
import 'package:flutter/material.dart';

class DiceGrid extends StatelessWidget {
  DiceGrid({Key key, this.listImages, this.color = const Color(0xFF2DBD3A), this.child, this.dices}) : super(key: key);

  final Color color;
  final Widget child;
  final double dices;
  final List<String> listImages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: listImages.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 20, crossAxisSpacing: 20),
        itemBuilder: (_, index) {
          return Image.asset(listImages[index], fit: BoxFit.cover, width: 100, height: 100);
        },
      ),
    );
  }
}
