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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sign_in_up.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.only(top: 80),
        alignment: Alignment.topCenter,
        child: Column(
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
            Text(
              'Welcome Back!',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 5),
            Text(
              "Let's sign in",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 40),
            Align(
                alignment: Alignment.centerLeft,
                widthFactor: 7,
                child: Text('Email',
                    style: Theme.of(context).textTheme.titleLarge)),
            const SizedBox(height: 5),
            SizedBox(
              width: 300,
              height: 40,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'abc@email.com',
                  hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.black54, fontStyle: FontStyle.italic),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 20),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
            const SizedBox(height: 20),
            Align(
                alignment: Alignment.centerLeft,
                widthFactor: 4,
                child: Text('Password',
                    style: Theme.of(context).textTheme.titleLarge)),
            const SizedBox(height: 5),
            SizedBox(
              width: 300,
              height: 40,
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: '********',
                  hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
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
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 300,
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
                      style: Theme.of(context).textTheme.headlineMedium)),
            ),
          ],
        ),
      ),
    );
  }
}
