import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lab_09/slot_row.dart';
import 'package:lab_09/sounds_service.dart';

class SlotMachine extends StatefulWidget {
  const SlotMachine({super.key});

  @override
  State<SlotMachine> createState() =>
      _SlotMachineState();
}

class _SlotMachineState
    extends State<SlotMachine> {
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
  var _isSpinning = false;
  var _isMuted = false;

  @override
  void initState() {
    super.initState();
    SoundsService.playBackground();
  }

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

    setState(() {
      _isSpinning = true;
      _message = '';
    });

    try {
      await SoundsService.playClick();

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

      String newMessage;
      int coinsChange;

      if (result1 == result2 &&
          result2 == result3) {
        if (result1 == 'img/assets/seven.png') {
          coinsChange = 10;
          newMessage =
              'джекпот! 🎰🎰🎰 +10 coins';
          await SoundsService.playJackpot();
        } else {
          coinsChange = 3;
          newMessage = 'win! 🎉 +3 coins';
          await SoundsService.playWin();
        }
      } else {
        coinsChange = -1;
        newMessage =
            'попробуй еще раз 😔 -1 coin';
        await SoundsService.playLose();
      }

      setState(() {
        _coins += coinsChange;
        _message = newMessage;
        _slot1 = result1;
        _slot2 = result2;
        _slot3 = result3;
      });
    } catch (e) {
      print('Ошибка: $e');
      setState(() {
        _message = 'Ошибка. Попробуйте еще раз.';
      });
    } finally {
      setState(() {
        _isSpinning = false;
      });
    }
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
        SizedBox(height: 12),
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
}
