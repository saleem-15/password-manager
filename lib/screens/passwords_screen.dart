// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/passwords_list.dart';
import '../helpers/colors.dart';

class PasswordScreen extends StatelessWidget {
  PasswordScreen({super.key});
  final searchController = TextEditingController();
  var searchText = ''.obs;

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
                controller: searchController,
                decoration: InputDecoration(
                  suffixIcon: Image.asset(
                    'lib/assets/search.png',
                    scale: 2,
                  ),
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
                onChanged: (value) => searchText.value = searchController.text,
              ),
            ),
            Expanded(
              child: Obx(
                () => PasswordsList(
                  searchText: searchText.value,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
