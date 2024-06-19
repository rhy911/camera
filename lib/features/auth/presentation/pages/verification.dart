import 'dart:async';

import 'package:Camera/core/utils/helper/message_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  late Timer timer;
  @override
  void initState() {
    super.initState();
    sendEmailVerification();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      FirebaseAuth.instance.currentUser!.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        timer.cancel();
        displayMessageToUser('Verification success', context);
        await Future.delayed(const Duration(seconds: 3));
        if (mounted) {
          Navigator.pop(context);
          Navigator.pop(context, true);
        }
      }
    });
  }

  Future<void> sendEmailVerification() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Email Verification'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      timer.cancel();
                      Navigator.pop(context, false);
                    },
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
              const Text(
                  'We sent you an email with a link to verify your account.\nPlease check your inbox'),
              ElevatedButton(
                onPressed: sendEmailVerification,
                child: const Text('Resend'),
              ),
            ],
          ),
        ));
  }
}
