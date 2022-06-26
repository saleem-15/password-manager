import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_manager/models/category.dart';
import 'package:password_manager/screens/auth_screen.dart';
import 'package:password_manager/screens/home_screen.dart';
import 'package:password_manager/screens/passwords_screen.dart';
import 'package:provider/provider.dart';

import 'helpers/colors.dart';
import 'models/password.dart';
import 'screens/add_new_passwoed_Screen.dart';

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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Passwordly',
      theme: ThemeData(
        primaryColor: blue,
      ),
      home:
          //  const App(),
          StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<PasswordsProvider>(
                  create: (context) => PasswordsProvider(),
                ),
                ChangeNotifierProvider<CategoryProvider>(
                  create: (context) => CategoryProvider(),
                ),
              ],
              builder: (_, child) => const App(),
            );
          }

          return const AuthScreen();
        },
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> screens = <Widget>[
    HomeScreen(),
    const PasswordScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddNewPasswordScreen(),
                ));
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: Center(
        child: screens.elementAt(_selectedIndex),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColor.withAlpha(150),
        onTap: _onItemTapped,
      ),
    );
  }
}
