// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_manager/api/firebase_api.dart';
import 'package:password_manager/utils/utils.dart';

import '../models/category.dart';
import '../models/password.dart';

class Dao {
  static final _instance = Dao();

  static Dao get instance => _instance;

  Box<Password> get passwordsBox => Hive.box('passwords_box');
  Box<Category> get categoryBox => Hive.box('categories_box');
  Box get myBox => Hive.box('box');

  Future<String> getUsername() async {
    String? username = myBox.get('userName');

    if (username == null) {
      final fetchedName = await FirebaseApi.getUsername();
      myBox.put('userName', fetchedName);

      username = fetchedName;
    }

    return username;
  }

  Future<void> addPassword(
    String websiteName,
    String url,
    String category,
    String emailOrUsername,
    String password,
    Timestamp lastUpdated,
    String id,
  ) async {
    final p = Password(
      category: category,
      email: emailOrUsername,
      icon: 'lib/assets/google.png',
      lastUpdated: Utils.formatDate(lastUpdated),
      password: password,
      url: url,
      websiteName: websiteName,
      id: id,
    );

    return await passwordsBox.put(p.id, p);
  }

  Future<void> deletePassword(String id) async {
    return await passwordsBox.delete(id);
  }

  List<Password> getAllPasswords() {
    return passwordsBox.values.toList();
  }

  Password? getPasswordById(String docId) {
    final results = passwordsBox.values.where((p) => p.id == docId);
    final Password? password = results.isEmpty ? null : results.first;
    return password;
  }

// *************************** CATEGORIES ******************************
  List<Category> getAllCategories() {
    return categoryBox.values.toList();
  }

  Future<void> addCategory(String name, String icon) async {
    final category = Category(name: name, icon: icon);
    return await categoryBox.put(name, category);
  }

  Future<void> deleteCategory(String name) async {
    return await categoryBox.delete(name);
  }

  Category? getCategoryByName(String name) {
    final results = categoryBox.values.where((p) => p.name == name);
    final Category? category = results.isEmpty ? null : results.first;
    return category;
  }

  void deleteCategoryPasswords(String categortName) {
    final newPasswordsList = passwordsBox.values.toList()
      ..removeWhere((element) => element.category == categortName);

    passwordsBox.clear();

    for (final password in newPasswordsList) {
      passwordsBox.put(password.id, password);
    }
  }
}
