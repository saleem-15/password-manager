import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/screens/password_details_screen.dart';

class PasswordTile extends StatelessWidget {
  const PasswordTile(
      {required this.websiteName,
      required this.email,
      required this.icon,
      required this.lastUpdate,
      required this.docId,
      required this.password,
      super.key});
  final String icon;
  final String websiteName;
  final String email;
  final String password;
  final String lastUpdate;
  final String docId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => PasswordDetailsScreen(docId: docId));
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(icon),
            backgroundColor: Colors.white,
          ),
          title: Text(
            websiteName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(email),
          trailing: IconButton(
            icon: Image.asset(
              'lib/assets/copy.png',
              width: 20,
              height: 20,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
