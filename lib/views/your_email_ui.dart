import 'package:flutter/material.dart';

class YourEmail extends StatefulWidget {
  const YourEmail({Key? key}) : super(key: key);

  @override
  State<YourEmail> createState() => _YourEmailState();
}

class _YourEmailState extends State<YourEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text(
          'Add/Edit Email',
        ),
        centerTitle: true,
      ),
    );
  }
}
