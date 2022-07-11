import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:password_manager/controllers/password_controller.dart';
import 'package:password_manager/screens/update_password_screen.dart';

import '../helpers/colors.dart';
import '../helpers/icons.dart';

class PasswordDetailsScreen extends StatelessWidget {
  const PasswordDetailsScreen({required this.id, super.key});

  final String id;

  /*
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

  checkIsThereFingerprint().then((value) => value
        ? fingerprint()
        : FirebaseFirestore.instance.collection('is not supported').add({}));
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PasswordController>(builder: (controller) {
        final password = controller.getPasswordById(id);
        final icon = SavedIcons.getIconPath(password.value.websiteName);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Row(
                children: [
                  if (icon != null)
                    Image.asset(
                      icon,
                      scale: 2,
                    ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    password.value.websiteName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: text_title_color,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),

              ///
              const Icon(
                Icons.person,
                size: 35,
                color: iconColor,
              ),

              const SizedBox(height: 10),
              Text(password.value.email),

              ///** */

              const SizedBox(height: 40),

              const Icon(
                Icons.lock,
                size: 35,
                color: iconColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
//************************** PASSWORD TEXT HERE **********************************
                  Text(password.value.password),
                  IconButton(
                    icon: Image.asset(
                      'lib/assets/copy.png',
                      scale: 3,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: password.value.password));

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
              Text(password.value.lastUpdated),

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
                          side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await controller.deletePassword(id);
                      Get.back();
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 50),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                    ),
                    child: const Text('Update'),
                    onPressed: () {
                      Get.to(() => UpdatePasswordScreen(id: id));
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        );
      }),
    );
  }
}
