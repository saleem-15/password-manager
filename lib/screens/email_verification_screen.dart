import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  var isEmailVerified = false;
  var canResendEmailVerification = true;
  late int canResendTimer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    FirebaseAuth.instance.currentUser!.sendEmailVerification();

    Timer.periodic(const Duration(seconds: 3), (timer) => checkIsEmailVerified(timer));
  }

  void checkIsEmailVerified(Timer timer) {
    //refreshs the data about the user
    FirebaseAuth.instance.currentUser!.reload();
    
    final isVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (isVerified) {
      timer.cancel();
      setState(() {
        isEmailVerified = true;
        App.isEmailVerified.value = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email verification'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'A verification email has been sent to your email',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: canResendEmailVerification
                  ? () {
                      FirebaseAuth.instance.currentUser!.sendEmailVerification();

                      setState(() {
                        canResendEmailVerification = false;
                      });

                      final t = Timer(
                        const Duration(seconds: 60),
                        () => canResendEmailVerification = true,
                      );

                      setState(() {
                        canResendTimer = 60 - t.tick;
                      });
                    }
                  : null,
              child: const Text('Resend Email'),
            ),
            if (!canResendEmailVerification) Text('can resend email in $canResendTimer'),
          ],
        ),
      ),
    );
  }
}
