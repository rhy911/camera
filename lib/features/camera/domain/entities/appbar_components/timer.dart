import 'dart:async';
import 'package:Camera/features/camera/provider/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerButton extends StatefulWidget {
  const TimerButton({super.key});

  @override
  State<TimerButton> createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.timer_rounded),
      onSelected: (int result) {
        Provider.of<CameraState>(context, listen: false).setTimer(result);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 0,
          child:
              Text('Off', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        const PopupMenuItem<int>(
          value: 3,
          child:
              Text('3s', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        const PopupMenuItem<int>(
          value: 10,
          child:
              Text('10s', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ],
    );
  }
}

Future<void> startTimer(int duration, Function(int) onTick) {
  Completer<void> completer = Completer<void>();

  Timer.periodic(const Duration(seconds: 1), (Timer t) {
    if (duration < 1) {
      t.cancel();
      debugPrint("Timer finished");
      completer.complete();
    } else {
      duration--;
      onTick(duration);
    }
  });

  return completer.future;
}
