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
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
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
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Welcome!\n',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontStyle: FontStyle.italic),
                  ),
                  TextSpan(
                    text: '\nSign up to get started',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontSize: 25),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70),
            SizedBox(
              width: 300,
              height: 40,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: const TextStyle(
                      color: Colors.black54, fontStyle: FontStyle.italic),
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
                  labelStyle: const TextStyle(
                      color: Colors.black54, fontStyle: FontStyle.italic),
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
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 40,
              child: TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(
                      color: Colors.black54, fontStyle: FontStyle.italic),
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
                  signUpUser();
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
