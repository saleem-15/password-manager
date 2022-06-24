import 'package:flutter/material.dart';
import 'package:password_manager/api/firebase_api.dart';
import 'package:password_manager/screens/passwords_screen.dart';

import '../screens/category_passwords_screen .dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({required this.categoryName, super.key});
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    var myIcon = Icons.home;
    var numPassword = 10;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: 
        (context) => CategoryPasswordScreen(categoryName: categoryName,)));
      },
      child: Container(
        height: 100,
        width: 110,
        margin: const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            const ImageIcon(AssetImage('lib/assets/people.png'), size: 30),
            const SizedBox(
              height: 12,
            ),
            FittedBox(
              child: Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            FutureBuilder(
              future: FirebaseApi.getNumOfPasswordsInCategory(categoryName),
              initialData: '',
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data} passwords',
                    style: TextStyle(color: Colors.grey[500]),
                  );
                }
    
                return Text(
                  '100 passwords',
                  style: TextStyle(color: Colors.grey[500]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
