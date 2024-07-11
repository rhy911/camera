import 'package:Camera/core/data/service/api_service.dart';
import 'package:Camera/core/utils/helper/message_dialog.dart';
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
        //POP LOADING CIRCLE
        if (context.mounted) {
          Navigator.pop(context);
          var verified =
              await Navigator.pushNamed(context, '/Email Verification') as bool;
          if (verified) {
            ApiService().createUserDocument(userCredential);
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/Main Screen');
            }
          } else {
            if (context.mounted) {
              userCredential.user!.delete();
              displayMessageToUser(
                  'You must verify your email to proceed', context);
            }
          }
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
            Text(
              'Hi!',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontStyle: FontStyle.italic),
            ),
            Text(
              'Sign up to get started',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            const SizedBox(height: 70),
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
                      color: Colors.black54, fontStyle: FontStyle.italic),
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
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: '********',
                  hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.black54, fontStyle: FontStyle.italic),
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
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  signUpUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0x9EF900BF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Continue',
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
