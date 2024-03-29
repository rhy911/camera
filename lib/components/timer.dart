import 'dart:async';
import 'package:flutter/material.dart';

class TimerButton extends StatefulWidget {
  final Function(int) onDurationChanged;

  const TimerButton({super.key, required this.onDurationChanged});

  @override
  State<TimerButton> createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  List<bool> isSelected = [true, false, false];
  Timer? timer;
  int setDuration = 0;

  void onTimerSelected(int index) {
    setState(() {
      switch (index) {
        case 0:
          print("timer off");
          setDuration = 0;
          break;
        case 1:
          print("timer 3");
          setDuration = 3;
          break;
        case 2:
          print("timer 10");
          setDuration = 10;
          break;
      }
      widget.onDurationChanged(setDuration);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: isSelected,
      color: Theme.of(context).iconTheme.color,
      selectedColor: Theme.of(context).iconTheme.color,
      fillColor: Colors.indigoAccent,
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
        Icon(Icons.timer_off),
        Icon(Icons.timer_3),
        Icon(Icons.timer_10),
      ],
    );
  }
}

Future<void> startTimer(int duration, Function(int) onTick) {
  Completer<void> completer = Completer<void>();

  Timer.periodic(const Duration(seconds: 1), (Timer t) {
    if (duration < 1) {
      t.cancel();
      print("Timer finished");
      completer.complete();
    } else {
      duration--;
      onTick(duration);
    }
  });

  return completer.future;
}
