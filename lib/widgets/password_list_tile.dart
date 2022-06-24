import 'package:flutter/material.dart';
import 'package:password_manager/screens/password_details_screen.dart';

class PasswordTile extends StatelessWidget {
  PasswordTile(
      {required this.websiteName,
      required this.email,
      required this.icon,
      required this.lastUpdate,
      required this.docId,
      required this.password,
      super.key});
  String icon;
  String websiteName;
  String email;
  String password;
  String lastUpdate;
  String docId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PasswordScreen(
                  docId: docId,
                )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
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
