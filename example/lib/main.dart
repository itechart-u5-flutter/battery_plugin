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
  String? currentLocation;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  Future<void> getCurrentLocation() async {
    try {
      final permission = await BatteryPlugin.askPermittion();
      if (permission != null && permission) {
        currentLocation = await BatteryPlugin.getCurrentLocation();
      } else {
        currentLocation = 'location denied';
      }

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Text('Current location is ${currentLocation ?? "..."}')),
      ),
    );
  }
}
