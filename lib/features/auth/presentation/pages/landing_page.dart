import 'package:Camera/config/themes/app_color.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "C A M - E D I T",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 150),
            SizedBox(
              width: 300,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColor.white,
                  backgroundColor: AppColor.midColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  "REGISTER NOW",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signin');
              },
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium),
                    TextSpan(
                      text: ' Login Here!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.purple,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
