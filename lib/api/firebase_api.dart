// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:password_manager/models/password.dart';
import '../utils/utils.dart';

class FirebaseApi {
  static final db = FirebaseFirestore.instance;

  static String get myUid {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<void> addNewUser(
      String username, String uid, String email) async {
    // the document id will be the uid of the user
    return await db.collection('users').doc(uid).set({
      'username': username,
      'email': email,
    });
  }

  static Future<String> getUsername() async {
    final user = await db.collection('users').doc(myUid).get();
    return user['username'];
  }

  static Future<void> addNewPassword(
    String websiteName,
    String url,
    String category,
    String emailOrUsername,
    String password,
    Timestamp lastUpdated,
    String id,
  ) async {
    await db.collection('users').doc(myUid).collection('passwords').doc(id).set({
      'website_name': websiteName,
      'url': url,
      'email': emailOrUsername,
      'password': password,
      'last_update': lastUpdated,
      'category': category
    });
    return;
  }

  static Future<Password> getPasswordByDocID(String docId) async {
    final doc = await db
        .collection('users')
        .doc(myUid)
        .collection('passwords')
        .doc(docId)
        .get();

    final password = Password(
      websiteName: doc['website_name'],
      icon: 'lib/assets/google.png',
      email: doc['email'],
      url: doc['url'],
      password: doc['password'],
      lastUpdated: Utils.formatDate(doc['last_update']),
      category: doc['category'],
      id: doc.id,
    );

    return password;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPasswords() {
    final passwordsStream =
        db.collection('users').doc(myUid).collection('passwords').snapshots();

    return passwordsStream;
  }

  static Future<void> deletePassword(String docId) async {
    return await db
        .collection('users')
        .doc(myUid)
        .collection('passwords')
        .doc(docId)
        .delete();
  }

  static Future<void> addNewCategory(String categoryName) async {
    //docId of a category = categoryName
    await db
        .collection('users')
        .doc(myUid)
        .collection('categories')
        .doc(categoryName)
        .set({});
    return;
  }

  static Future<List<String>> getAllCategories() async {
    List<String> categories = [];
    final passwords =
        await db.collection('users').doc(myUid).collection('categories').get();

    passwords.docs.forEach((category) {
      categories.add(category.id);
    });
    return categories;
  }

  static Future<void> deleteCategory(String docId) async {
    return await db
        .collection('users')
        .doc(myUid)
        .collection('categories')
        .doc(docId)
        .delete();
  }

  static Future<int> getNumOfPasswordsInCategory(String categoryName) async {
    var x = await db
        .collection('users')
        .doc(myUid)
        .collection('passwords')
        .where('category', isEqualTo: categoryName)
        .get();

    return x.size;
  }

  static Future<List<Password>> getPasswordsInCategory(
      String categoryName) async {
    List<Password> passwordsList = [];

    final passwords = await db
        .collection('users')
        .doc(myUid)
        .collection('passwords')
        .where('category', isEqualTo: categoryName)
        .get();

    passwords.docs.forEach((password) {
      final p = Password(
          websiteName: password['website_name'],
          email: password['email'],
          url: password['url'],
          password: password['password'],
          lastUpdated: Utils.formatDate(password['last_update'] as Timestamp),
          icon: 'lib/assets/facebook.png',
          category: password['category'],
          id: password.id,
          );

      passwordsList.add(p);
    });
    return passwordsList;
  }
}
