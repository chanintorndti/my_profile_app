import 'package:flutter/material.dart';

class YourAboutUI extends StatefulWidget {
  const YourAboutUI({Key? key}) : super(key: key);

  @override
  State<YourAboutUI> createState() => _YourAboutUIState();
}

class _YourAboutUIState extends State<YourAboutUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text(
          'Add/Edit About',
        ),
        centerTitle: true,
      ),
    );
  }
}
