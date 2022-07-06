// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:get/get.dart';
import 'package:password_manager/controllers/category_controller.dart';
import 'package:password_manager/helpers/colors.dart';

import '../controllers/password_controller.dart';

class AddNewPasswordScreen extends StatefulWidget {
  const AddNewPasswordScreen({super.key});

  @override
  State<AddNewPasswordScreen> createState() => _AddNewPasswordScreenState();
}

class _AddNewPasswordScreenState extends State<AddNewPasswordScreen> {
  TextEditingController websiteNameController = TextEditingController();

  TextEditingController urlController = TextEditingController();

  TextEditingController emaiOrUsernameController = TextEditingController();

  TextEditingController passController = TextEditingController();

  TextEditingController categoryController = TextEditingController();
  late Timestamp _timestamp;
  @override
  Widget build(BuildContext context) {
    final PasswordController passwordController = Get.find();

  //TODO validate this form (category if exists)
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
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
                    labelText: 'Name',
                    constraints: BoxConstraints(maxHeight: 50),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                //
                const SizedBox(height: 20),
                //
                const SizedBox(height: 10),
                TextFormField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'URL',
                    constraints: BoxConstraints(maxHeight: 50),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                //
                const SizedBox(height: 20),
                //
                const SizedBox(height: 10),
                TextFormField(
                  controller: emaiOrUsernameController,
                  decoration: const InputDecoration(
                    labelText: 'Email/Username',
                    constraints: BoxConstraints(maxHeight: 50),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
                //
                const SizedBox(height: 20),
                //
                const SizedBox(height: 10),
                TextFormField(
                  controller: passController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    constraints: BoxConstraints(maxHeight: 50),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                //
                const SizedBox(height: 10),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    constraints: BoxConstraints(maxHeight: 50),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    bool categoryExists = Get.find<CategoryController>()
                        .checkCategoryExists(value);

                    if (categoryExists) return null;
                    return 'There is no category with this name';
                  },
                ),

                const SizedBox(
                  height: 30,
                ),
                const Text('Password Strength'),

                FlutterPasswordStrength(
                    password: passController.text,
                    strengthCallback: (strength) {
                      debugPrint(strength.toString());
                    }),

                const SizedBox(height: 20),

                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 10),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                    ),
                    child: const Text(
                      'Add New Password',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      final websiteEmail = websiteNameController.text.trim();
                      final password = passController.text.trim();
                      final websiteName = websiteNameController.text.trim();
                      final url = urlController.text.trim();
                      final category = categoryController.text.trim();

                      _timestamp = Timestamp.now();
                      final id = _timestamp.toString();

                      passwordController.addNewPassword(
                        websiteName,
                        url,
                        category,
                        websiteEmail,
                        password,
                        _timestamp,
                        id,
                      );

                      passController.clear();
                      websiteNameController.clear();
                      emaiOrUsernameController.clear();
                      urlController.clear();
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
