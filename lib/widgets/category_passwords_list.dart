// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/password_controller.dart';
import 'password_tile.dart';

class CategoryPasswordsList extends StatelessWidget {
  const CategoryPasswordsList({required this.searchText, required this.categoryName, super.key});
  final String categoryName;
  final String searchText;

  @override
  Widget build(BuildContext context) {
    return GetX<PasswordController>(
      builder: (controller) {
        final list = controller.getCategoryPasswords(categoryName);
        var searchedList = list;

   
        //search logic
        if (searchText.isNotEmpty) {
          searchedList = list.where((p) {
            final searchLower = searchText.toLowerCase();
            final websiteNameLower = p.value.websiteName.toLowerCase();
            if (websiteNameLower.startsWith(searchLower)) {
              return true;
            }
            return false;
          }).toList();
        }

        return searchedList.isEmpty && searchText.isNotEmpty
            ? const Center(
                child: Text(
                  'There is no results',
                  style: TextStyle(fontSize: 20),
                ),
              )
            : ListView(
                children: searchedList
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PasswordTile(
                          docId: e.value.id,
                        ),
                      ),
                    )
                    .toList(),
              );
      },
    );
  }
}
