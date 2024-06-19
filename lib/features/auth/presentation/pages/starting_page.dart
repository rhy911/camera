import 'package:Camera/core/utils/components/theme_switch.dart';
import 'package:flutter/material.dart';

class StartingScreen extends StatelessWidget {
  const StartingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          const PositionedDirectional(
            bottom: 60,
            end: 50,
            child: ThemeSwitch(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "&C A M\nE D I T&",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 70,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFFAC29B8),
                      shadows: [
                        const Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Color(0xFFFFFFFF),
                        ),
                      ]),
                ),
                const SizedBox(height: 100),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFFFFFFFF),
                      backgroundColor: const Color(0xFFAC29B8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      shadowColor: const Color(0xFF979DBB),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/Sign Up');
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
                    Navigator.pushNamed(context, '/Sign In');
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
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
        ],
      ),
    );
  }
}
