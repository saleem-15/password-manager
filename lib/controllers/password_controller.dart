import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:password_manager/api/firebase_api.dart';

import '../utils/utils.dart';
import '../dao/dao.dart';
import '../models/password.dart';

class PasswordController extends GetxController {
  PasswordController() {
    initilizePasswordsList();
  }

  final db = Dao.instance;
  final passwordsList = <Rx<Password>>[].obs;

  void initilizePasswordsList() {
    final passwords = RxList(db.getAllPasswords());
    for (var element in passwords) {
      passwordsList.add(element.obs);
    }
  }

  Future<void> intilizeDataFromBackend() async {
    final passwords = await FirebaseApi.getAllPasswords();
    Dao.instance.addListOfPasswords(passwords);
    addListOfPasswords(passwords);
  }

  void addListOfPasswords(List<Password> list) {
    for (var password in list) {
      passwordsList.add(password.obs);
    }
  }

  void addNewPassword(String websiteName, String category, String emailOrUsername, String password, Timestamp lastUpdated, String id) async {
    await Dao.instance.addPassword(
      //local storage
      websiteName,
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
      password: password,
      lastUpdated: Utils.formatDate(lastUpdated),
      category: category,
      id: id,
    ).obs;

    passwordsList.add(p);

    //back-end
    FirebaseApi.addNewPassword(websiteName, category, emailOrUsername, password, lastUpdated, id);
  }

  void updatePassword(String id, String newPassword) {
    final updateTime = Timestamp.now();
    final passwordIndex = passwordsList.indexWhere((element) => element.value.id == id);
    final element = passwordsList[passwordIndex].value;
    element.password = newPassword;
    element.lastUpdated = Utils.formatDate(updateTime);

    update();
    //local-storage
    db.updatePassword(id, newPassword, updateTime);

    //back-end
    FirebaseApi.updatePassword(id, newPassword);
  }

  Future<void> deletePassword(String id) async {
    // await FirebaseApi.deletePassword(docId);

    passwordsList.removeWhere((element) => element.value.id == id); //remove from the list
    update();
    await Dao.instance.deletePassword(id); //remove from the DB

    //back-end
    FirebaseApi.deletePassword(id);
  }

  Rx<Password> getPasswordById(String id) {
    return passwordsList.firstWhere((element) => element.value.id == id);
  }

  List<Rx<Password>> getCategoryPasswords(String categoryName) {
    return passwordsList.where((p) => p.value.category == categoryName).toList();
  }

  void deleteCategoryPasswords(String categoryName) {
    passwordsList.removeWhere((password) => password.value.category == categoryName);

    //local-storage
    db.deleteCategoryPasswords(categoryName);

    //back-end
    FirebaseApi.deleteCategoryPasswords(categoryName);
  }

  int getNumOfPasswordsInCategory(String categoryName) {
    return passwordsList.where((e) => e.value.category == categoryName).length;
  }

  List<Map<String, Object>> findReusedPasswords() {
    /// this list has one copy of each password
    /// (if there is 10 accounts with the same password then the password exists only once in this list)
    final List<Map<String, Object>> passwords = [];

    /// this list has the accounts that there password is not unique
    final List<Map<String, Object>> result = [];

    for (var element in passwordsList) {
      //if the password is not unique
      if (passwords.any((e) => element.value.password == e['password'])) {
        final indexOfExistingPassword = passwords.indexWhere((e) => e['password'] == element.value.password);
        (passwords[indexOfExistingPassword]['accountsIds'] as List<String>).add(element.value.id);
      } else {
        // if the password is not in the list
        passwords.add({
          'password': element.value.password,
          'accountsIds': [element.value.id],
        });
      }
    }

    // for (var element in passwords) {
    //   log('password: ${element['password']}');
    //   log('accounts Ids: ');
    //   for (var element in (element['accountsIds'] as List<String>)) {
    //     log('id: $element****');
    //   }
    // }

    for (var element in passwords) {
      final listOfAccounts = element['accountsIds'] as List<String>;

      if (listOfAccounts.length != 1) {
        result.add(element);
      }
    }

    return result;
  }

  List<Password> getReusedPasswords() {
    final p = findReusedPasswords();
    final List<Password> reusedPasswords = [];

    for (var element in p) {
      for (var passwordId in (element['accountsIds'] as List<String>)) {
        reusedPasswords.add(getPasswordById(passwordId).value);
      }
    }

    return reusedPasswords;
  }

  int numOfSimilarPasswords() {
    final list = findReusedPasswords();
    var reusedTimes = 0;
    for (var element in list) {
      final num = (element['accountsIds'] as List<String>).length;
      if (num > 1) {
        reusedTimes += num;
      }
    }
    return reusedTimes;
  }
}
