import 'package:flutter/material.dart';

TextStyle smallText(Color fontColor, {bool fontWeight = false}) {
  return TextStyle(
      fontSize: 16,
      color: fontColor,
      fontWeight: fontWeight ? FontWeight.bold : FontWeight.normal);
}

TextStyle mediumText(Color fontColor, {bool fontWeight = false}) {
  return TextStyle(
      fontSize: 25,
      color: fontColor,
      fontWeight: fontWeight ? FontWeight.bold : FontWeight.normal);
}
TextStyle largeText(Color fontColor, {bool fontWeight = false}) {
  return TextStyle(
      fontSize: 40,
      color: fontColor,
      fontWeight: fontWeight ? FontWeight.bold : FontWeight.normal);
}

const Color greenColor = Color(0xFF2AAA8A);
const Color blueColor = Color(0xFF189AB4);
const Color salmonColor = Color(0xFFE4A58F);