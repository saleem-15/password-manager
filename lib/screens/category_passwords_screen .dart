// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_manager/controllers/category_controller.dart';

import '../controllers/password_controller.dart';
import '../helpers/colors.dart';
import '../widgets/category_passwords_list.dart';

class CategoryPasswordScreen extends StatefulWidget {
  const CategoryPasswordScreen({required this.categoryName, super.key});
  ///this widget is stateful only to use the dispose method

  final String categoryName;

  @override
  State<CategoryPasswordScreen> createState() => _CategoryPasswordScreenState();
}

class _CategoryPasswordScreenState extends State<CategoryPasswordScreen> {
  final searchController = TextEditingController();

  var searchText = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(widget.categoryName),
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
                    title: 'Are you sure you want to delete the category and all of its passwords',
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
                          Get.find<CategoryController>().deleteCategory(widget.categoryName);
                          Get.find<PasswordController>().deleteCategoryPasswords(widget.categoryName);
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
                  controller: searchController,
                  decoration: InputDecoration(
                    suffixIcon: Image.asset(
                      'lib/assets/search.png',
                      scale: 2,
                    ),
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => searchText.value = searchController.text,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Obx(
                () => CategoryPasswordsList(
                  categoryName: widget.categoryName,
                  searchText: searchText.value,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    super.dispose();
  }
}
