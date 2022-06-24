import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/widgets/passwords_list.dart';

import 'package:password_manager/api/firebase_api.dart';
import 'package:provider/provider.dart';
import '../helpers/colors.dart';
import '../models/password.dart';
import '../widgets/categories_list.dart';
import '../widgets/passwords_analytics.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final email = 'saleemmahdi10@gmail.com';

  List<Password> passwordsList = [];

  @override
  Widget build(BuildContext context) {
    makeStatusBarTransparent();
    Provider.of<PasswordsProvider>(context).getAllPasswords();

    return ChangeNotifierProvider(
      create: (context) => PasswordsProvider(),
      builder: (context, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 60),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 60,
                      right: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Welcome',
                              style: TextStyle(color: lightGrey),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            FutureBuilder(
                              future: FirebaseApi.getUsername(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('');
                                }

                                return Text(
                                  snapshot.data ?? 'soso',
                                  style: const TextStyle(color: lightGrey),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const CircleAvatar(
                          backgroundImage: AssetImage('lib/assets/man.png'),
                        )
                      ],
                    ),
                  ),
                  const PasswordsAnalytics(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.only(left: 25.0, right: 25, top: 40),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Your Passwords',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  const CategoriesList(),
                  const SizedBox(
                    height: 20,
                  ),
                  const PasswordsList()
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void makeStatusBarTransparent() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }
}
