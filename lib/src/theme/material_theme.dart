import 'package:flutter/material.dart';

abstract class MaterialTheme {
  const MaterialTheme();

  ThemeData light();

  ThemeData dark();
}
