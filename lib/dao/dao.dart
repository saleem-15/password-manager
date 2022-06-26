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
      docId: id,
      icon: 'lib/assets/google.png',
      lastUpdated: Utils.formatDate(lastUpdated),
      password: password,
      url: url,
      websiteName: websiteName,
      id: id,
    );

    return await passwordsBox.put('s', p);
  }

  Future<void> deletePassword(String id) async {
    return await passwordsBox.delete(id);
  }

  Future<List<Password>> getAllPasswords() async {
    final x = await passwordsBox.values.toList();
    return x;
  }
}
