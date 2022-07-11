import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../api/firebase_api.dart';
import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
  ) async {
    UserCredential authResult;
/*
    // try {
    //   setState(() {
    //     isLoading = true;
    //   });

    //   if (isLogin) {
    //     // already existing User
    //     authResult = await _auth.signInWithEmailAndPassword(
    //       email: email,
    //       password: password,
    //     );
    //   } else {
    //     // New Uer
    //     authResult = await _auth.createUserWithEmailAndPassword(
    //       email: email,
    //       password: password,
    //     );

    //     final ref = FirebaseStorage.instance
    //         .ref()
    //         .child('user_image')
    //         .child('${authResult.user!.uid}.jpg');

    //     await ref.putFile(image!).whenComplete(() => null);

    //     final imageUrl = await ref.getDownloadURL();

    //     await FirebaseFirestore
    //         .instance // add the new user to the "users" collection
    //         .collection('users')
    //         .doc(authResult.user!.uid)
    //         .set({
    //       'username': username,
    //       'email': email,
    //       'image_url': imageUrl,
    //     });
    //   }
    // }

    */
    try {
      setState(() {
        isLoading = true;
      });

      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        //new Account
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
                await FirebaseApi.addNewUser(username, authResult.user!.uid, email);





        /*

        // final ref = FirebaseStorage.instance
        //     .ref()
        //     .child('user_image')
        //     .child('${authResult.user!.uid}.jpg');

        // await ref.putFile(image!).whenComplete(() => null);

        // final url = await ref.getDownloadURL();
        */

      }
    } on FirebaseAuthException catch (error) {
      String msg;
      setState(() {
        isLoading = false;
      });
      log(error.code);

      switch (error.code) {
        case 'email-already-in-use':
          msg = 'The email is already in use';
          break;
        case 'wrong-password':
          msg = 'wrong password';
          break;

        case 'user-not-found':
          msg = 'There is no user with this email';
          break;

        default:
          msg = error.code;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 7),
        ),
      );
    }
  }

  var isEmailVerificationMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue,
                  Colors.purple,
                  Colors.red,
                ],
              ),
            ),
          ),
          AuthForm(_submitAuthForm, isLoading),
        ],
      ),
    );
  }
}
