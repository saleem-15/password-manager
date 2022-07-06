import 'package:get/get.dart';
import 'package:password_manager/models/category.dart';

import '../dao/dao.dart';

class CategoryController extends GetxController {
  CategoryController() {
    initilizecategoriesList();
  }

  final db = Dao.instance;
  final categoriesList = <Category>[].obs;

  void initilizecategoriesList() {
    final categories = RxList(db.getAllCategories());
    categoriesList.addAll([...categories]);
  }

  void addNewCategory(
    String name,
    String icon,
  ) async {
    await db.addCategory(
      //local storage
      name,
      icon,
    );

    final p = Category(
      name: name,
      icon: icon,
    );

    categoriesList.add(p);
  }

  Future<void> deleteCategory(String name) async {
    // await FirebaseApi.deletePassword(docId);
    await db.deleteCategory(name); //remove from the DB
    categoriesList
        .removeWhere((element) => element.name == name); //remove from the list
  }

  Future<Category?> getCategoryByName(String docId) async {
    // FirebaseApi.getPasswordByDocID(docId);

    return db.getCategoryByName(docId);
  }

  bool checkCategoryExists(categoryName) {
    return categoriesList.any((category) => category.name == categoryName);
  }
}
