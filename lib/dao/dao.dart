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

  bool get isDataInitilizedFromBackend {
    return myBox.get('is_data_initilized_from_backend', defaultValue: false);
  }

  void dataIsInitializedFromBackend() {
    myBox.put('is_data_initilized_from_backend', true);
  }

  void addListOfPasswords(List<Password> list) async {
    for (var password in list) {
      passwordsBox.put(password.id, password);
    }
  }

  void addListOfCategories(List<String> list) async {
    for (var category in list) {
      addCategory(category, 'lib/assets/people.png');
    }
  }

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
    String category,
    String email,
    String password,
    Timestamp lastUpdated,
    String id,
  ) async {
    final p = Password(
      id: id,
      websiteName: websiteName,
      email: email,
      password: password,
      category: category,
      lastUpdated: Utils.formatDate(lastUpdated),
      icon: 'lib/assets/google.png',
    );

    return await passwordsBox.put(p.id, p);
  }

  Future<void> deletePassword(String id) async {
    return await passwordsBox.delete(id);
  }

  List<Password> getAllPasswords() {
    var p = passwordsBox.values.toList();

    return p;
  }

  Password? getPasswordById(String id) {
    final results = passwordsBox.values.where((p) => p.id == id);
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
    final newPasswordsList = passwordsBox.values.toList()..removeWhere((element) => element.category == categortName);

    passwordsBox.clear();

    for (final password in newPasswordsList) {
      passwordsBox.put(password.id, password);
    }
  }

  void updatePassword(String id, String newPassword, Timestamp lastUpdate) {
    final p = getPasswordById(id);
    p!.password = newPassword;
    p.lastUpdated = Utils.formatDate(lastUpdate);
    passwordsBox.put(id, p);
  }
}
