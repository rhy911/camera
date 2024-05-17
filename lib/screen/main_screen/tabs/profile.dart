import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> userEmails = [];
  @override
  void initState() {
    super.initState();
    _fetchUserEmails();
  }

  Future<void> _fetchUserEmails() async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      userEmails = usersSnapshot.docs
          .map((doc) => (doc.data())['email'].toString())
          .toList();
    });

    debugPrint('Fetched ${userEmails.length} user emails from Firestore');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, '/start');
          },
          color: Colors.red,
          textColor: Colors.white,
          child: const Text('Sign Out'),
        ),
        Text(
          FirebaseAuth.instance.currentUser!.email!,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    ));
  }
}
