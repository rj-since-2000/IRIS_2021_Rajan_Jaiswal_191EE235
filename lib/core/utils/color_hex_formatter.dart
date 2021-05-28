import 'package:flutter/material.dart';

Color colorFromHex(String hex) {
  // example - aa09b3
  String color = '0xff' + hex.trim();
  return Color(int.parse(color));
}
