import 'package:flutter/material.dart';

import '../models/password.dart';
import 'password_list_tile.dart';

class PasswordsList extends StatelessWidget {
  const PasswordsList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PasswordsProvider().getPasswords(),
      builder: (BuildContext context, AsyncSnapshot<List<Password>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text('There is no passwords'),
          );
        }
        return ListView(
          
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