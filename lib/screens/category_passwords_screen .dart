import 'package:flutter/material.dart';

import '../api/firebase_api.dart';
import '../helpers/colors.dart';
import '../models/password.dart';
import '../widgets/password_list_tile.dart';

class CategoryPasswordScreen extends StatelessWidget {
  const CategoryPasswordScreen({required this.categoryName, super.key});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 80, left: 15, right: 15),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: textFieldBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: Image.asset(
                    'lib/assets/search.png',
                    scale: 2,
                  ),
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: FirebaseApi.getPasswordsInCategory(categoryName),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Password>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.isEmpty) {
                    return const Center(child: Text('There is no passwords'));
                  }
                  return ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    children: snapshot.data!
                        .map((e) => PasswordTile(
                              lastUpdate: e.lastUpdated,
                              password: e.password,
                              email: e.email,
                              icon: e.icon,
                              docId: e.docId,
                              websiteName: e.websiteName,
                            ))
                        .toList(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
