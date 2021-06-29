import 'package:flutter/material.dart';
import 'package:battery_plugin/battery_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FutureBuilder(
            future: BatteryPlugin.platformVersion,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final version = snapshot.data;
                return Text('Running on: $version\n');
              } else {
                return Text('Error...');
              }
            },
          ),
        ),
      ),
    );
  }
}
