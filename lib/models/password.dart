import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:password_manager/api/firebase_api.dart';
import 'package:password_manager/utils/utils.dart';

class Password {
  String websiteName; //website ,app,service  Name
  String icon;
  String email;
  String password;
  String lastUpdated;
  String url;
  String docId;
  String category;

  Password({
    required this.websiteName,
    required this.docId,
    required this.icon,
    required this.email,
    required this.url,
    required this.password,
    required this.lastUpdated,
    required this.category,
  });
}

class PasswordsProvider with ChangeNotifier {
  void addNewPassword(String websiteName, String url, String category,
      String emailOrUsername, String password) async {
    await FirebaseApi.addNewPassword(
        websiteName, url, category, emailOrUsername, password);

    notifyListeners();
  }

  Future<void> deletePassword(String docId) async {
    await FirebaseApi.deletePassword(docId);

    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPasswords() {
    final passwords = FirebaseApi.getAllPasswords();
    return passwords;
  }

  Future<int> getNumOfPasswordsInCategory(String categoryName) async {
    final num = await FirebaseApi.getNumOfPasswordsInCategory(categoryName);

    notifyListeners();
    return num;
  }


}
