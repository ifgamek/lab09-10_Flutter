import 'package:flutter/material.dart';
import 'slot_machine.dart';
import 'sounds_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SoundsService.init();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepPurple,
        body: SlotMachine(),
      ),
    ),
  );

}
