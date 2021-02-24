import 'package:flutter/material.dart';

class Constants{
  static final backgroundColor= new LinearGradient(
      colors: [
        Colors.grey[900],
        Colors.black,
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topRight,
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);

}