// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/controllers/category_controller.dart';

import '../controllers/password_controller.dart';
import '../helpers/colors.dart';
import '../widgets/password_list_tile.dart';

class CategoryPasswordScreen extends StatelessWidget {
  const CategoryPasswordScreen({required this.categoryName, super.key});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        centerTitle: true,
        actions: [
          //with tooltip and round border corner(if you also needed those)

          PopupMenuButton<int>(
            shape: const RoundedRectangleBorder(
              //Adding Round Border
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            onSelected: (value) {
              if (value == 1) {
                Get.defaultDialog(
                    titlePadding: const EdgeInsets.all(10),
                    content: const SizedBox.shrink(),
                    title:
                        'Are you sure you want to delete the category and all of its passwords',
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      ElevatedButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          Get.back(); //get back from the dialog
                          Get.back(); //get back from the category screen that you have deleted
                          Get.find<CategoryController>()
                              .deleteCategory(categoryName);
                          Get.find<PasswordController>()
                              .deleteCategoryPasswords(categoryName);                              

                        },
                      ),
                    ]
                    // textCancel: 'Cancel',

                    // textConfirm: 'delete',
                    );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text("delete category"),
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: textFieldBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: Image.asset(
                      'lib/assets/search.png',
                      scale: 2,
                    ),
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            GetX<PasswordController>(
              builder: (controller) {
                final passwords = controller.getCategoryPasswords(categoryName);

                if (passwords.isEmpty) {
                  return const Expanded(
                    child: Center(child: Text('There is no passwords')),
                  );
                }

                return Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    children: passwords
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: PasswordTile(
                                lastUpdate: e.lastUpdated,
                                password: e.password,
                                email: e.email,
                                icon: e.icon,
                                docId: e.id,
                                websiteName: e.websiteName,
                              ),
                            ))
                        .toList(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
