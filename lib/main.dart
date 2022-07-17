import 'package:flutter/material.dart';
import 'package:my_profile_app/views/home_ui.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeUI(),
      theme: ThemeData(
        fontFamily: 'Kanit',
      ),
    ),
  );
}
