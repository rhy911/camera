import 'package:flutter/material.dart';

class StartingScreen extends StatelessWidget {
  const StartingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/starting_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "&C A M\nE D I T&",
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 70,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFFEC20C0),
                        shadows: [
                          const Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Color(0xFFFFFFFF),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 80),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFFFFFFFF),
                        backgroundColor: const Color(0xFFFF0095),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        shadowColor: const Color(0xFF979DBB),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/Sign Up');
                      },
                      child: Text(
                        "REGISTER NOW",
                        style: Theme.of(context).textTheme.titleLarge,
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
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Already have an account? ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(shadows: [
                                const Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 0.5,
                                  color: Color(0xFF000000),
                                ),
                              ])),
                          TextSpan(
                              text: ' Login Here!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: const Color(0xFFFF0095),
                                      shadows: [
                                    const Shadow(
                                      offset: Offset(0.5, 0.5),
                                      blurRadius: 0.5,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ])),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
