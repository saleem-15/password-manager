import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_manager/api/firebase_api.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category {

    @HiveField(0)
  String name;

    @HiveField(1)
  String icon;

  Category({
    required this.name,
    required this.icon,
  });
}

class CategoryProvider with ChangeNotifier {
  final List<Category> _categories = [];

  Future<void> addNewCategory(String categoryName) async {
    await FirebaseApi.addNewCategory(categoryName);
    _categories.add(
      Category(
        name: categoryName,
        icon: 'lib/assets/google.png',
      ),
    );

    notifyListeners();
    return;
  }

  Future<List<Category>> getAllCategories() async {
    final passwords = await FirebaseApi.getAllCategories();
    _categories.clear(); //delete the old data

    passwords.forEach((categoryName) {
      _categories.add(
        Category(
          name: categoryName,
          icon: 'lib/assets/google.png',
        ),
      );
    });
    notifyListeners();
    //return a copy of the categories list (not a direct refrence to '_categories')
    return [..._categories];
  }

  Future<void> deleteCategory(String docId) async {
    await FirebaseApi.deleteCategory(docId);
    // docId  = category name
    _categories.removeWhere((element) => element.name == docId);
    notifyListeners();
    return;
  }
}
