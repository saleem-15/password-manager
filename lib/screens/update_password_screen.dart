import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/password_controller.dart';
import '../helpers/colors.dart';

class UpdatePasswordScreen extends StatelessWidget {
  UpdatePasswordScreen({required this.id, super.key});
  final String id;
  final newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final passwordController = Get.find<PasswordController>();
    final password = passwordController.getPasswordById(id);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 100,
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
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.person,
                  size: 35,
                  color: iconColor,
                ),
                const SizedBox(height: 10),
                Text(password.value.email),
                //
                const SizedBox(height: 30),
                //
                const Icon(
                  Icons.link,
                  size: 35,
                  color: iconColor,
                ),
                // const SizedBox(height: 10),
                // Text(password.value.url),
                //
                const SizedBox(height: 30),
                //
                const Icon(
                  Icons.lock,
                  size: 35,
                  color: iconColor,
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration:
                      const InputDecoration.collapsed(hintText: 'New Password'),
                  controller: newPasswordController,
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

                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(
                      MediaQuery.of(context).size.width - 40,
                      40,
                    )),
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
                  child: const Text('Update Password'),
                  onPressed: () {
                    passwordController.updatePassword(
                      id,
                      newPasswordController.text.trim(),
                    );

                    Get.back();
                  },
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
