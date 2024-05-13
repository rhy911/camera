import 'package:Camera/helper/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  //SIGN UP USER
  Future<void> signUpUser() async {
    var context = this.context;
    //SHOW LOADING CIRCLE
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    //CONFIRM PASSWORD MATCH
    if (_passwordController.text != _confirmPasswordController.text) {
      //POP LOADING CIRCLE
      Navigator.pop(context);
      //SHOW ERROR MESSAGE
      displayMessageToUser('Password dont match', context);
    } else {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        createUserDocument(userCredential);
        //POP LOADING CIRCLE
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          //POP LOADING CIRCLE
          Navigator.pop(context);
          //SHOW ERROR MESSAGE
          displayMessageToUser(e.code, context);
        }
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.email)
          .set({
        'uid': userCredential.user!.uid,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 50),
              ],
            ),
            RichText(
              text: const TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Hello!\n',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 50,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text: '\nSign Up to get started',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: const TextStyle(color: Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white38,
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 20),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white54,
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 20),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 300,
              height: 50,
              child: TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(color: Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white54,
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 20),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  signUpUser();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'CONTINUE   ->',
                  style: TextStyle(fontSize: 25, color: Colors.deepPurple[500]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}