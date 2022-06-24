import 'package:flutter/material.dart';

import '../widgets/passwords_list.dart';
import '../helpers/colors.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

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
            const PasswordsList()
          ],
        ),
      ),
    );
  }
}
