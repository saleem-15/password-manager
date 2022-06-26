import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_manager/api/firebase_api.dart';
import 'package:password_manager/dao/Dao.dart';

part 'password.g.dart';

@HiveType(typeId: 1)
class Password {
  @HiveField(0)
  String websiteName; //(website,app,service) Name

  @HiveField(1)
  String icon;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  @HiveField(4)
  String lastUpdated;

  @HiveField(5)
  String url;

  @HiveField(6)
  String docId;

  @HiveField(7)
  String category;

  @HiveField(8)
  String id;

  Password({
    required this.websiteName,
    required this.docId,
    required this.icon,
    required this.email,
    required this.url,
    required this.password,
    required this.lastUpdated,
    required this.category,
    required this.id,
  });
}

class PasswordsProvider with ChangeNotifier {
  void addNewPassword(
    String websiteName,
    String url,
    String category,
    String emailOrUsername,
    String password,
    Timestamp lastUpdated,
    String id,
  ) async {
    try{
        await FirebaseApi.addNewPassword(
      //firebase storage
      websiteName,
      url,
      category,
      emailOrUsername,
      password,
      lastUpdated,
      id,
    );
    } on PlatformException{
//sad
    }
    

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

    notifyListeners();
  }

  Future<void> deletePassword(String docId) async {
   // await FirebaseApi.deletePassword(docId);
    await Dao.instance.deletePassword(docId);

    notifyListeners();
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> getAllPasswords() {
  //   final passwords = FirebaseApi.getAllPasswords();
  //   return passwords;
  // }

  Future<List<Password>> getPasswords() async {
     return  await Dao.instance.getAllPasswords();

  }

  Future<int> getNumOfPasswordsInCategory(String categoryName) async {
    final num = await FirebaseApi.getNumOfPasswordsInCategory(categoryName);

    notifyListeners();
    return num;
  }
}
