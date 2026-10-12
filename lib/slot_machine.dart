
import 'dart:math';

import 'package:flutter/material.dart';

class SlotMachine extends StatefulWidget {
  const SlotMachine({super.key});

  @override
  State<SlotMachine> createState() =>
      _SlotMachineState();
}



class _SlotMachineState
    extends State<SlotMachine> {

  void _reset(){
    setState(() {
      _coins = 10;
      _slot1 = 'img/assets/cherry.png';
      _slot2 = 'img/assets/lemon.png';
      _slot3 = 'img/assets/seven.png';
      _message = '';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'coins: $_coins',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(_slot1, width: 100, height: 100),
            SizedBox(width: 16),

            Image.asset(_slot2, width: 100, height: 100),
            SizedBox(width: 16),

            Image.asset(_slot3, width: 100, height: 100),
            
          ],
        ),
        SizedBox(height: 24),
        Text(
          _message,
          style:TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 40),

        ElevatedButton(onPressed: _coins > 0?_spin : null, 
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,   
           padding: EdgeInsets.symmetric(
            horizontal: 48, vertical: 16,
          ),
        ),
        child: Text('Spin',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        ),
          ),
          ElevatedButton(onPressed: _reset, child: Text(
            'начать заново',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ))
      ],
    );
    
  }

  final _random = Random();

  final _symbols = [
    'img/assets/cherry.png',
    'img/assets/lemon.png',
    'img/assets/seven.png',
  ];
  
  var _coins = 10;
  var _slot1 = 'img/assets/cherry.png';
  var _slot2 = 'img/assets/lemon.png';
  var _slot3 = 'img/assets/seven.png';
  var _message = '';

  void _spin() {
    if (_coins <= 0){
      setState(()
      {_message = 'no coins';
      });
      return;
    }

    setState(() {
      _slot1 = _symbols[_random.nextInt(_symbols.length)];
      _slot2 = _symbols[_random.nextInt(_symbols.length)];
      _slot3 = _symbols[_random.nextInt(_symbols.length)];
    
    if (_slot1 == _slot2 && _slot2 == _slot3){
      _coins += 3;
      _message = 'win! +3 coins';
    }
    else 
    {
      _coins -= 1;
      _message = 'lose. -3 coins';
    }
  });
}
    }