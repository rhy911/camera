import 'package:Camera/screen/camera_screen.dart';
import 'package:flutter/material.dart';

class Add extends StatelessWidget {
  const Add({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 100, 56, 172),
            automaticallyImplyLeading: false,
            title: const Text(
              'Camera App',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 240,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 200, 20, 230),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 30),
                          SizedBox(width: 20),
                          Text(
                            'Import',
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 240,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CameraApp()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 200, 20, 230),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.camera_enhance_rounded,
                              color: Colors.white, size: 30),
                          SizedBox(width: 20),
                          Text(
                            'Take Picture',
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          )),
    );
  }
}
