// ignore_for_file: file_names, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:get/get.dart';
import 'package:password_manager/controllers/category_controller.dart';
import 'package:password_manager/helpers/colors.dart';
import 'package:random_password_generator/random_password_generator.dart';

import '../controllers/password_controller.dart';

class AddNewPasswordScreen extends StatelessWidget {
  AddNewPasswordScreen({super.key});

  final websiteNameController = TextEditingController();
  final emaiOrUsernameController = TextEditingController();
  final passController = TextEditingController();
  final categoryController = TextEditingController();

  late Timestamp _timestamp;

  //this variable exists only to achive real time update to the (FlutterPasswordStrength) widget
  var passwordString = ''.obs;
  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final PasswordController passwordController = Get.find();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 120,
                ),
                const Text(
                  'Add New Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: text_title_color,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),

                const SizedBox(height: 10),
                TextFormField(
                  controller: websiteNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    labelText: 'Website/App',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'required';
                    return null;
                  },
                ),
                //
                // const SizedBox(height: 20),
                // //
                // const SizedBox(height: 10),
                // TextFormField(
                //   controller: urlController,
                //   decoration: const InputDecoration(
                //     labelText: 'URL',
                //     contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(15)),
                //     ),
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return null;
                //     }
                //     RegExp exp = RegExp(
                //         "(https?://(?:www.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9].[^s]{2,}|www.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9].[^s]{2,}|https?://(?:www.|(?!www))[a-zA-Z0-9]+.[^s]{2,}|www.[a-zA-Z0-9]+.[^s]{2,})");
                //     if (exp.hasMatch(value)) {
                //       return null;
                //     }
                //     return 'Enter a valid url';
                //   },
                // ),
                //
                const SizedBox(height: 20),
                //
                const SizedBox(height: 10),
                TextFormField(
                  controller: emaiOrUsernameController,
                  decoration: const InputDecoration(
                    labelText: 'Email/Username',
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'required';
                    return null;
                  },
                ),
                //
                const SizedBox(height: 20),
                //
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: passController,
                        onChanged: (password) => passwordString.value = password,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'required';
                          return null;
                        },
                      ),
                    ),
                    TextButton(
                      child: const Text('auto generate'),
                      onPressed: () {
                        final generatedPassword = RandomPasswordGenerator().randomPassword(
                          uppercase: true,
                          numbers: true,
                          specialChar: true,
                          passwordLength: 10,
                        );

                        passController.text = generatedPassword;
                        passwordString.value = generatedPassword;
                      },
                    )
                  ],
                ),

                const SizedBox(height: 20),
                //
                const SizedBox(height: 10),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    bool categoryExists = Get.find<CategoryController>().checkCategoryExists(value);

                    if (categoryExists) return null;
                    return 'There is no category with this name';
                  },
                ),

                const SizedBox(
                  height: 30,
                ),
                const Text('Password Strength'),
                const SizedBox(
                  height: 10,
                ),

                Obx(
                  () => FlutterPasswordStrength(
                      password: passwordString.value,
                      radius: 10,
                      height: 10,
                      duration: const Duration(milliseconds: 1000),
                      strengthCallback: (strength) {
                        debugPrint(strength.toString());
                      }),
                ),

                const Spacer(),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                    ),
                    child: const Text(
                      'Add New Password',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      final email = emaiOrUsernameController.text.trim();
                      final password = passController.text.trim();
                      final websiteName = websiteNameController.text.trim();
                      final category = categoryController.text.trim();

                      _timestamp = Timestamp.now();
                      final id = _timestamp.toString();

                      passwordController.addNewPassword(
                        websiteName,
                        category,
                        email,
                        password,
                        _timestamp,
                        id,
                      );

                      passController.clear();
                      websiteNameController.clear();
                      emaiOrUsernameController.clear();
                      categoryController.clear();
                    },
                  ),
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
