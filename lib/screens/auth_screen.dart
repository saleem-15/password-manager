import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../api/firebase_api.dart';
import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
  ) async {
    UserCredential authResult;

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
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // final ref = FirebaseStorage.instance
        //     .ref()
        //     .child('user_image')
        //     .child('${authResult.user!.uid}.jpg');

        // await ref.putFile(image!).whenComplete(() => null);

        // final url = await ref.getDownloadURL();

        await FirebaseApi.addNewUser(username, authResult.user!.uid, email);
      }
    } on PlatformException catch (error) {
      var msg = 'An error occured, please check your credentials!';
      setState(() {
        isLoading = false;
      });

      if (error.message != null) {
        msg = error.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
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
        AuthForm(_submitAuthForm, isLoading)
      ]),
    );
  }
}
