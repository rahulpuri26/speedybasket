import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/addpro.dart';
import 'package:speedy_basket/adminpanel.dart';
import 'package:speedy_basket/approveshop.dart';
import 'package:speedy_basket/catgmst.dart';
import 'package:speedy_basket/fetchusers.dart';
import 'package:speedy_basket/firebase_options.dart';
import 'package:speedy_basket/logi2n.dart';
import 'package:speedy_basket/mainpage.dart';
import 'package:speedy_basket/pratice.dart';
import 'package:speedy_basket/shopkdash.dart';
import 'package:speedy_basket/signup.dart';
import 'package:speedy_basket/userdashboard.dart';

void main() async {
  // initialize app binding
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences sharedPref = await SharedPreferences.getInstance();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MainApp(sharedPref: sharedPref));
}

class MainApp extends StatelessWidget {
  final SharedPreferences sharedPref;
  MainApp({super.key, required this.sharedPref});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome(sharedpref: sharedPref));
  }
}

class MyHome extends StatelessWidget {
  final SharedPreferences sharedpref;
  MyHome({super.key, required this.sharedpref});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => MainPage(sharedPref: sharedpref,)));
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  color: Colors.red,
                  child: Center(
                    child: Text("1"),
                  ),
                )),
                Expanded(
                    child: Container(
                  color: Colors.amber,
                  child: Center(),
                )),
                Expanded(
                    child: Container(
                  color: Colors.indigo,
                  child: Center(
                    child: Text("3"),
                  ),
                ))
              ],
            ),
          ),
          Expanded(
              child: Row(
            children: [
              Expanded(
                  child: Container(
                color: Color.fromARGB(255, 55, 220, 5),
                child: Center(
                  child: Text("4"),
                ),
              )),
              Expanded(
                  child: Container(
                color: Color.fromARGB(255, 109, 3, 214),
                child: Center(
                  child: Text("5"),
                ),
              )),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              Expanded(
                  child: Container(
                color: Color.fromARGB(255, 13, 238, 201),
                child: Center(
                  child: Text("6"),
                ),
              )),
              Expanded(
                  child: Container(
                color: Color.fromARGB(255, 244, 144, 12),
                child: Center(
                  child: Text("7"),
                ),
              )),
              Expanded(
                  child: Container(
                color: Color.fromARGB(255, 6, 166, 220),
                child: Center(
                  child: Text("8"),
                ),
              )),
              Expanded(
                  child: Container(
                color: Color.fromARGB(255, 184, 10, 227),
                child: Center(
                  child: Text("9"),
                ),
              )),
            ],
          )),
        ],
      ),
    );
  }
}
