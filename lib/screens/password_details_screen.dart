import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:password_manager/api/firebase_api.dart';
import 'package:password_manager/models/password.dart';

import '../helpers/colors.dart';

class PasswordScreen extends StatelessWidget {
  PasswordScreen(
      {
      // required this.websiteName,
      // required this.lastUpdated,
      // required this.password,
      // required this.icon,
      // required this.email,
      required this.docId,
      super.key});
  // String websiteName;
  // String icon;
  // String password;
  // String lastUpdated;
  // String email;
  String docId;

  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> checkIsThereFingerprint() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    if (!canAuthenticate) {
      return false;
    }

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    if (availableBiometrics.isEmpty) {
      return false;
    }

    if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return true;
    }
    return false;
  }

  fingerprint() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to open the app',
        options: const AuthenticationOptions(
            biometricOnly:
                false), //this prevents the phone from using any security except fingerprint
      );
      // ···
    } on PlatformException {
      // ...
    }
  }

  @override
  Widget build(BuildContext context) {
    checkIsThereFingerprint().then((value) => value
        ? fingerprint()
        : FirebaseFirestore.instance.collection('is not supported').add({}));
    return FutureBuilder(
        future: FirebaseApi.getPasswordByDocID(docId),
        initialData: Password(
          docId: ' ',
          category: ' ',
          email: ' ',
          icon: ' ',
          lastUpdated: ' ',
          password: ' ',
          url: ' ',
          websiteName: ' ',
          id: ' ',
        ),
        builder: (BuildContext context, AsyncSnapshot<Password> snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No data'),
            );
          }
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    snapshot.data!.websiteName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: text_title_color,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Icon(
                    Icons.person,
                    size: 35,
                    color: iconColor,
                  ),
                  const SizedBox(height: 10),
                  Text(snapshot.data!.email),
                  //
                  const SizedBox(height: 30),
                  //
                  const Icon(
                    Icons.link,
                    size: 35,
                    color: iconColor,
                  ),
                  const SizedBox(height: 10),
                  Text(snapshot.data!.url),
                  //
                  const SizedBox(height: 30),
                  //
                  const Icon(
                    Icons.lock,
                    size: 35,
                    color: iconColor,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(snapshot.data!.password),
                      IconButton(
                        icon: Image.asset(
                          'lib/assets/copy.png',
                          scale: 3,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: snapshot.data!.password));

                          Fluttertoast.showToast(
                            msg: "Password is copied!!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            fontSize: 16.0,
                          );
                        },
                      )
                    ],
                  ),
                  //
                  const SizedBox(height: 30),
                  //
                  const Icon(
                    Icons.calendar_today,
                    size: 30,
                    color: iconColor,
                  ),
                  const SizedBox(height: 10),
                  Text(snapshot.data!.lastUpdated),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 50),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await PasswordsProvider().deletePassword(docId);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Delete',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 50),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                        ),
                        child: const Text('Update'),
                        onPressed: () {},
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          );
        });
  }
}
