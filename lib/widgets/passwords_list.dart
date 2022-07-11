// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/password_controller.dart';
import 'password_tile.dart';

class PasswordsList extends StatelessWidget {
  const PasswordsList({required this.searchText, super.key});
  final String searchText;

  @override
  Widget build(BuildContext context) {
    return GetX<PasswordController>(
      builder: (controller) {
        final list = controller.passwordsList;
        var searchedList = list.value;

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
                padding: const EdgeInsets.all(8.0),
                children: searchedList
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
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

// StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: PasswordsProvider().getPasswords(),
//         builder: (BuildContext context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('There is no passwords'));
//           }
//           return ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//             children: snapshot.data!.docs
//                 .map((DocumentSnapshot password) => PasswordTile(
//                       websiteName: password['website_name'],
//                       email: password['email'],
//                       password: password['password'],
//                       lastUpdate: Utils.formatDate(password['last_update']),
//                       icon: 'lib/assets/google.png',
//                       docId: password.id,
//                     ))
//                 .toList(),
//           );
//         },
//       ),

/// the old code 

// FutureBuilder(
//       future: FirebaseApi.getAllPasswords(),
//       builder: (BuildContext context, AsyncSnapshot<List<Password>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.data!.isEmpty) {
//           return const Center(
//               child: Center(child: Text('There is no passwords')));
//         }
//         return Expanded(
//           child: ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             children: snapshot.data!
//                 .map((e) => PasswordTile(
//                       lastUpdate: e.lastUpdated,
//                       password: e.password,
//                       email: e.email,
//                       icon: e.icon,
//                       docId: e.docId,
//                       websiteName: e.websiteName,
//                     ))
//                 .toList(),
//           ),
//         );
//       },
//     );