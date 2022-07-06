import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import '../dao/dao.dart';
import '../models/password.dart';

class PasswordController extends GetxController {
  PasswordController() {
    initilizePasswordsList();
  }

  final db = Dao.instance;
  final passwordsList = <Password>[].obs;

  void initilizePasswordsList() {
    final passwords = RxList(db.getAllPasswords());
    passwordsList.addAll([...passwords]);
  }

  void addNewPassword(
    String websiteName,
    String url,
    String category,
    String emailOrUsername,
    String password,
    Timestamp lastUpdated,
    String id,
  ) async {
    await Dao.instance.addPassword(
      //local storage
      websiteName,
      url,
      category,
      emailOrUsername,
      password,
      lastUpdated,
      id,
    );

    final p = Password(
      websiteName: websiteName,
      icon: 'lib/assets/google.png',
      email: emailOrUsername,
      url: url,
      password: password,
      lastUpdated: Utils.formatDate(lastUpdated),
      category: category,
      id: id,
    );

    passwordsList.add(p);
  }

  Future<void> deletePassword(String id) async {
    // await FirebaseApi.deletePassword(docId);
    await Dao.instance.deletePassword(id); //remove from the DB
    passwordsList
        .removeWhere((element) => element.id == id); //remove from the list
  }

  Future<Password?> getPasswordByDocID(String docId) async {
    // FirebaseApi.getPasswordByDocID(docId);

    return db.getPasswordById(docId);
  }

  List<Password> getCategoryPasswords(String categoryName) {
    return passwordsList.where((p) => p.category == categoryName).toList();
  }

  void deleteCategoryPasswords(String categoryName) {
    passwordsList.removeWhere((password) => password.category == categoryName);
    db.deleteCategoryPasswords(categoryName);
  }

  List<Map<String, Object>> findSimilarPasswords() {
    //this list has one copy of each password
    //(if there is 10 accounts with the same password then the password exists only once in this list)

    // final uniquePasswords = passwordsList.toSet().toList();

    final List<Map<String, Object>> passwords = [];

    for (var element in passwordsList) {
      //if the password is not unique
      if (passwords.any((e) => element.password == e['password'])) {
        final indexOfExistingPassword =
            passwords.indexWhere((e) => e['password'] == element.password);
        (passwords[indexOfExistingPassword]['accountsIds'] as List<String>)
            .add(element.id);
      } else {
        // if the password is not in the list
        passwords.add({
          'password': element.password,
          'accountsIds': [element.id],
        });
      }
    }

    for (var element in passwords) {
      log('password: ${element['password']}');
      log('accounts Ids: ');
      for (var element in (element['accountsIds'] as List<String>)) {
        log('id: $element****');
      }
    }

    return passwords;
  }

  int getNumOfPasswordsInCategory(String categoryName) {
    return passwordsList.where((e) => e.category == categoryName).length;
  }

  int numOfSimilarPasswords() {
    final list = findSimilarPasswords();
    var reusedTimes = 0;
    for (var element in list) {
      reusedTimes += (element['accountsIds'] as List<String>).length;
    }
    return reusedTimes;
  }
}
