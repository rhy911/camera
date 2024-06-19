import 'package:Camera/core/utils/helper/message_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key});

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signInUser() async {
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
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      //POP LOADING CIRCLE
      if (context.mounted) {
        Navigator.pop(context);
      }
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/Main Screen');
      }
    } on FirebaseAuthException {
      if (context.mounted) {
        //POP LOADING CIRCLE
        Navigator.pop(context);
        //SHOW ERROR MESSAGE
        displayMessageToUser('Error! Please try again', context);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const SizedBox(height: 30),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Welcome Back!\n',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontStyle: FontStyle.italic),
                  ),
                  TextSpan(
                    text: '\nSign in',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 300,
              height: 40,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 40,
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 20),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  signInUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0x9EF900BF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Continue',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: const Color(0xFFFFFFFF),
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
