import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/controllers/password_controller.dart';

import '../screens/category_passwords_screen .dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({required this.categoryName, super.key});
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(CategoryPasswordScreen(categoryName: categoryName));
      },
      child: Container(
        height: 100,
        width: 110,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            const ImageIcon(AssetImage('lib/assets/people.png'), size: 30),
            const SizedBox(
              height: 12,
            ),
            FittedBox(
              child: Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              Get.find<PasswordController>()
                  .getNumOfPasswordsInCategory(categoryName)
                  .toString(),
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
