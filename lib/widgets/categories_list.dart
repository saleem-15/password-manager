import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/controllers/category_controller.dart';

import '../screens/add_new_category_screen.dart';
import 'category_tile.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 140),
      child: GetX<CategoryController>(
        builder: (controller) => ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...controller.categoriesList
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: CategoryTile(categoryName: e.name),
                  ),
                )
                .toList(),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: InkWell(
                onTap: () {
                  Get.to(() => const AddNewCategory());
                },
                child: Container(
                  width: 110,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: const Center(child: Icon(Icons.add)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
