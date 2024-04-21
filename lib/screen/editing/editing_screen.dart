import 'package:flutter/material.dart';

class EditingScreen extends StatefulWidget {
  const EditingScreen({super.key, required this.image});
  final Image image;
  @override
  State<EditingScreen> createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title:
            const Text('Editing Screen', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: widget.image,
      ),
    );
  }
}
