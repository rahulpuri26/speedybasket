import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/logi2n.dart';
import 'package:speedy_basket/signupuser.dart';

class MainPage extends StatefulWidget {
  final SharedPreferences sharedPref;
  MainPage({super.key, required this.sharedPref});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              color: Color.fromARGB(255, 248, 242, 241),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.11),
                  const Text(
                    "Welcome to Speedy Basket",
                    style: TextStyle(
                      color: Color.fromARGB(255, 9, 9, 9),
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Metropolis',
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Container(
                    height: constraints.maxHeight * 0.25,
                    child: Image.asset('assets/logo2.png'),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.15),
                      child: Text(
                        "Your shortcut to hassle-free online grocery shopping. Fresh, fast, and delivered to your door.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.19),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.1),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                log2in(sharedPref: widget.sharedPref),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                        side: BorderSide(color: Colors.white),
                        padding: EdgeInsets.all(15.0),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth * 0.1),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                signupuser(sharedPref: widget.sharedPref),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.black),
                        padding: EdgeInsets.all(15.0),
                      ),
                      child: Text(
                        "Create an Account",
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Terms of Service",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Metropolis',
                            fontSize: 10,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Metropolis',
                            fontSize: 10,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Contact Support",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Metropolis',
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
