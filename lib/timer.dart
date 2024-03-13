import 'dart:async';
import 'package:flutter/material.dart';

class TimerMenu extends StatefulWidget {
  final Function onTimerFinished;

  const TimerMenu({super.key, required this.onTimerFinished});

  @override
  State<TimerMenu> createState() => _TimerMenuState();
}

class _TimerMenuState extends State<TimerMenu> {
  List<bool> isSelected = [true, false, false];
  Timer? timer;

  void onTimerSelected(int index) {
    while (index < isSelected.length && isSelected[index]) {
      switch (index) {
        case 0:
          timer?.cancel();
          widget.onTimerFinished();
          break;
        case 1:
          print("timer 3");
          startTimer(3);
          break;
        case 2:
          startTimer(10);
          break;
      }
      index++;
    }
  }

  void startTimer(int seconds) {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (seconds < 1) {
        t.cancel();
        print("Timer finished");
        widget.onTimerFinished();
      } else {
        seconds--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: isSelected,
      fillColor: Colors.deepPurpleAccent,
      onPressed: (int newIndex) {
        setState(() {
          for (int index = 0; index < isSelected.length; index++) {
            if (index == newIndex) {
              isSelected[index] = true;
            } else {
              isSelected[index] = false;
            }
          }
          onTimerSelected(newIndex);
        });
      },
      children: const [
        Icon(Icons.timer_off, color: Colors.white),
        Icon(Icons.timer_3, color: Colors.white),
        Icon(Icons.timer_10, color: Colors.white),
      ],
    );
  }
}
