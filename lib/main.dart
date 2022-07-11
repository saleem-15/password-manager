// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_manager/api/firebase_api.dart';
import 'package:password_manager/screens/add_password.dart';
import 'package:password_manager/screens/email_verification_screen.dart';

import '../controllers/category_controller.dart';
import '../models/category.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/passwords_screen.dart';
import 'controllers/password_controller.dart';
import 'dao/dao.dart';
import 'helpers/colors.dart';
import 'models/password.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Firebase.initializeApp();
  Hive.registerAdapter(PasswordAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await Hive.openBox<Password>('passwords_box');
  await Hive.openBox<Category>('categories_box');
  await Hive.openBox('box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //make status bar color transparent
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Passwordly',
      theme: ThemeData(
        primaryColor: blue,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //if the user logged in
          if (snapshot.hasData) {
            return App();
          }

          //if not logged in
          return const AuthScreen();
        },
      ),
    );
  }
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _selectedIndex = 0.obs;
  late final PasswordController passwordController;
    late final CategoryController categoryController;


  static List<Widget> screens = <Widget>[
    const HomeScreen(),
    PasswordScreen(),
  ];

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  static final isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified.obs;
  @override
  Widget build(BuildContext context) {
    //make status bar dark
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ));

    //define controllers
    passwordController = Get.put(PasswordController());
    categoryController = Get.put(CategoryController());

    intilizeDataFromBackend();
    return Obx(() {
      return !isEmailVerified.value

          // if user account is created but the email is not verified
          ? const EmailVerificationScreen()

          // if user logged in and the email is  verified
          : Scaffold(
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: _selectedIndex.value == 1
                  ? FloatingActionButton(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        Get.to(() => AddNewPasswordScreen());
                      },
                      child: const Icon(Icons.add),
                    )
                  : null,
              body: Center(
                child: screens.elementAt(_selectedIndex.value),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
                elevation: 0,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('lib/assets/home.png')),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage('lib/assets/unlock.png'),
                    ),
                    label: 'Password',
                  ),
                ],
                currentIndex: _selectedIndex.value,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Theme.of(context).primaryColor.withAlpha(150),
                onTap: _onItemTapped,
              ),
            );
    });
  }

  Future<void> intilizeDataFromBackend() async {
    //if the user has downloaded the app and there is some data stored previously in the back end
    if (!Dao.instance.isDataInitilizedFromBackend) {
      passwordController.intilizeDataFromBackend();

      categoryController.intilizeDataFromBackend();

      //set in the database 'is_data_initilized_from_backend' to true
      Dao.instance.dataIsInitializedFromBackend();
    }
  }
}
