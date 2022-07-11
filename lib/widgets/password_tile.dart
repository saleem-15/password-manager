import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:password_manager/controllers/password_controller.dart';
import 'package:password_manager/screens/password_details_screen.dart';

import '../helpers/icons.dart';

class PasswordTile extends StatelessWidget {
  const PasswordTile(
      {required this.docId,
      //   required this.websiteName,
      // required this.email,
      // required this.icon,
      // required this.lastUpdate,
      // required this.password,
      super.key});
  // final String icon;
  // final String websiteName;
  // final String email;
  // final String password;
  // final String lastUpdate;
  final String docId;

  @override
  Widget build(BuildContext context) {
    final password = Get.find<PasswordController>().getPasswordById(docId);
    // if (password == null) return const SizedBox.shrink();
    final icon = SavedIcons.getIconPath(password.value.websiteName);

    return InkWell(
      onTap: () {
        Get.to(() => PasswordDetailsScreen(id: docId));
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: icon != null
              ? CircleAvatar(
                  backgroundImage: AssetImage(icon),
                  backgroundColor: Colors.white,
                )
              : const SizedBox.shrink(),
          title: Text(
            password.value.websiteName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(password.value.email),
          trailing: IconButton(
            icon: Image.asset(
              'lib/assets/copy.png',
              width: 20,
              height: 20,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: password.value.password));

              Fluttertoast.showToast(
                msg: "Password is copied!!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 16.0,
              );
            },
          ),
        ),
      ),
    );
  }
}
