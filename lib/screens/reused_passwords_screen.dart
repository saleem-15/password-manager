import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:password_manager/widgets/password_tile.dart';

import '../controllers/password_controller.dart';
import '../models/password.dart';

class ReusedPasswordsScreen extends StatelessWidget {
  const ReusedPasswordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordController>(builder: (controller) {
      final numOfReusedPasswords = controller.numOfSimilarPasswords();

      return Scaffold(
        body: numOfReusedPasswords == 0
            ? const Center(
                child: Text(
                  'There is no reused passwords',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : GroupedListView<Password, String>(
                elements: controller.getReusedPasswords(),
                groupBy: (element) => element.password,
                groupSeparatorBuilder: (reusedPassword) => Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('The password ', style: TextStyle(fontSize: 18)),
                        Text(
                          reusedPassword,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            ' is used on these sites and apps',
                            softWrap: true,
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                itemBuilder: (context, password) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PasswordTile(docId: password.id),
                ),
              ),
      );
    });
  }

  // ListView.separated(
  //      itemCount: reusedPassword.length ,
  //       itemBuilder: (context, index) => PasswordTile(docId: reusedPassword[index]),
  //       separatorBuilder:(context, index) => Te,
  //     ),
}
