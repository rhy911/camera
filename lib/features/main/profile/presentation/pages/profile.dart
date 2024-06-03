import 'package:Camera/core/utils/components/theme_switch.dart';
import 'package:Camera/features/editor/provider/image_provider.dart'
    as provider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Consumer<provider.ImageProvider>(
      builder: (BuildContext context, imageProvider, Widget? child) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () {
                  imageProvider.reset();
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/Starting Page');
                },
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Sign Out'),
              ),
              Text(
                FirebaseAuth.instance.currentUser?.email ?? 'No current user',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const ThemeSwitch()
            ],
          ),
        );
      },
    );
  }
}
