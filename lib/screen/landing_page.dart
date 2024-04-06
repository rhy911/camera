import 'package:Camera/screen/sign_up.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 100, 56, 172),
      body: Stack(
        children: [
          Positioned(
            left: 25,
            right: 25,
            top: 540,
            bottom: 275,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.indigoAccent[100],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpWidget()),
                );
              },
              child: const Text(
                "TẠO TÀI KHOẢN",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Positioned(
            top: 600,
            left: 80,
            right: 80,
            bottom: 200,
            child: TextButton(
              onPressed: () {},
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Đã có tài khoản? '),
                    TextSpan(
                      text: 'Đăng nhập ngay',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Color.fromARGB(255, 247, 201, 158)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            top: 200,
            left: 90,
            right: 90,
            bottom: 600,
            child: Center(
              child: Text(
                "CAMERA APP",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
