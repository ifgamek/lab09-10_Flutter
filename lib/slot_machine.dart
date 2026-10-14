import 'dart:math';

import 'package:lab_09/slot_row.dart';
import 'package:flutter/material.dart';

import 'sounds_service.dart';

class SlotMachine extends StatefulWidget {
  const SlotMachine({super.key});

  @override
  State<SlotMachine> createState() =>
      _SlotMachineState();
}

class _SlotMachineState
    extends State<SlotMachine> {
  @override
  void initState() {
    super.initState();
    SoundsService.playBackgtound();
  }

  var _coins = 10;
  var _slot1 = 'img/assets/cherry.png';
  var _slot2 = 'img/assets/lemon.png';
  var _slot3 = 'img/assets/seven.png';
  var _message = '';
  var _isSpinning = false;
  var _isMuted = false;
  var _backgrounStarted = false;

  void _reset() {
    setState(() {
      _coins = 10;
      _slot1 = 'img/assets/cherry.png';
      _slot2 = 'img/assets/lemon.png';
      _slot3 = 'img/assets/seven.png';
      _message = '';
      _isSpinning = false;
    });
  }

  void _toggleMute() {
    SoundsService.toggleMute();
    setState(() {
      _isMuted = SoundsService.isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(
              right: 16,
              top: 8,
            ),
            child: IconButton(
              onPressed: _toggleMute,
              icon: Icon(
                _isMuted
                    ? Icons.volume_off
                    : Icons.volume_up,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        Text(
          'coins: $_coins',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 40),
        AnimatedOpacity(
          opacity: _isSpinning ? 0.85 : 1.0,
          duration: Duration(milliseconds: 100),
          child: SlotRow(
            slot1: _slot1,
            slot2: _slot2,
            slot3: _slot3,
          ),
        ),

        SizedBox(
          height: 36,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: Text(
              _isSpinning
                  ? 'spin! ...'
                  : _message,
              key: ValueKey(
                _isSpinning
                    ? 'spinning'
                    : _message,
              ),
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight:
                    _message.contains('джекпот')
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ),

        ElevatedButton(
          onPressed: _coins > 0 && !_isSpinning
              ? _spin
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: EdgeInsets.symmetric(
              horizontal: 48,
              vertical: 16,
            ),
          ),
          child: Text(
            _isSpinning ? 'spinning...' : 'spin',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        SizedBox(
          height: 12,
        ), // Отступ между кнопками
        TextButton(
          onPressed: _isSpinning ? null : _reset,
          child: Text(
            'начать заново',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  final _random = Random();

  final _symbols = [
    'img/assets/cherry.png',
    'img/assets/lemon.png',
    'img/assets/seven.png',
  ];

  Future<String> _spinReel({
    required int totalTicks,
    required void Function(String) onTick,
  }) async {
    String result = _symbols[0];
    for (int i = 0; i < totalTicks; i++) {
      final progress = i / totalTicks;
      final delay = progress < 0.5
          ? 40
          : progress < 0.8
          ? 100
          : 200;

      await Future.delayed(
        Duration(milliseconds: delay),
      );
      result =
          _symbols[_random.nextInt(
            _symbols.length,
          )];
      onTick(result);
    }
    return result;
  }

  Future<void> _spin() async {
    if (_coins <= 0 || _isSpinning) return;
    SoundsService.playClick();
    setState(() {
      _message = '';
    });
    if (!_backgrounStarted) {
      SoundsService.playBackgtound();
      _backgrounStarted = true;
    }
    final result1 = await _spinReel(
      totalTicks: 10,
      onTick: (val) =>
          setState(() => _slot1 = val),
    );

    final result2 = await _spinReel(
      totalTicks: 13,
      onTick: (val) =>
          setState(() => _slot2 = val),
    );

    final result3 = await _spinReel(
      totalTicks: 16,
      onTick: (val) =>
          setState(() => _slot3 = val),
    );

    await Future.delayed(
      Duration(milliseconds: 300),
    );

    setState(() {
      _isSpinning = false;
      if (result1 == result2 &&
          result2 == result3) {
        if (result1 == 'img/assets/seven.png') {
          _coins += 10;
          _message = 'джекпот! +10 coins';
          SoundsService.playJackpot();
        } else {
          _coins += 3;
          _message = 'win! +3 coins';
          SoundsService.playWin();
        }
      } else {
        _coins -= 1;
        _message = 'попробуй еще раз -1 coins';
        SoundsService.playLose();
      }
    });

    setState(() {
      _slot1 =
          _symbols[_random.nextInt(
            _symbols.length,
          )];
      _slot2 =
          _symbols[_random.nextInt(
            _symbols.length,
          )];
      _slot3 =
          _symbols[_random.nextInt(
            _symbols.length,
          )];

      if (_slot1 == _slot2 && _slot2 == _slot3) {
        _coins += 3;
        _message = 'win! +3 coins';
      } else {
        _coins -= 1;
        _message = 'lose. -3 coins';
      }
    });
  }
}
