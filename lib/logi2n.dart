import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/adminpanel.dart';
import 'package:speedy_basket/signupuser.dart';
import 'package:toastification/toastification.dart';
import 'package:speedy_basket/catgmst.dart';
import 'package:speedy_basket/dummy.dart';
import 'package:speedy_basket/shopkdash.dart';
import 'package:speedy_basket/signup.dart';
import 'package:speedy_basket/userdashboard.dart';

class log2in extends StatefulWidget {
  final SharedPreferences sharedPref;
  log2in({super.key, required this.sharedPref});

  @override
  State<log2in> createState() => _log2inState();
}

class _log2inState extends State<log2in> {
  TextEditingController emailcontroller1 = TextEditingController();
  TextEditingController passcontroller1 = TextEditingController();
  bool isLogin = false;
  final loginformkey = GlobalKey<FormState>();
  List<dynamic> al = [];
  String role = '';
  String status = '';

  Future<void> signin() async {
    try {
      UserCredential loginCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller1.text,
        password: passcontroller1.text,
      );
      String mid = loginCredential.user!.uid.toString();

      if (mid != null && mid.isNotEmpty) {
        CollectionReference category =
            FirebaseFirestore.instance.collection("users");
        QuerySnapshot snapshot =
            await category.where("uid", isEqualTo: mid).get();
        for (var data in snapshot.docs) {
          // get all data
          String email = data["email"];
          String name = data["name"];
          String password = data["password"];
          String phone = data["phone"];
          String uid = data["uid"];
          String role = data["role"];
          String status = data["status"];
          al.addAll([email, name, password, phone, uid, role, status]);
          this.role = role;
          this.status = status;
        }
        setState(() {
          isLogin = true;
        });
        print(al);
        // Navigation logic
        if (isLogin) {
          rolelogin();
        }
      }
    } catch (error) {
      setState(() {
        isLogin = false;
      });
      toastification.show(
        context: context,
        title: Text("Wrong Credentials. Please Sign Up or Reset your Account"),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  void showtoast() {
    toastification.show(
      context: context,
      title: Text("Logged In Successfully"),
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  void rolelogin() async {
    if (role == "admin") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AdminPanel(sharedPref: widget.sharedPref),
        ),
      );
      showtoast();
      toastification.show(
        context: context,
        title: Text("Welcome Admin"),
        type: ToastificationType.success,
        style: ToastificationStyle.minimal,
        autoCloseDuration: const Duration(seconds: 7),
      );
    } else if (role == "User") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => userdashboard(sharedPref: widget.sharedPref),
        ),
      );
      showtoast();
      toastification.show(
        context: context,
        title: Text("Welcome User"),
        type: ToastificationType.success,
        style: ToastificationStyle.minimal,
        autoCloseDuration: const Duration(seconds: 7),
      );
    } else if (role == "ShopKeeper" && status == "approved") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => shopkdash(sharedPref: widget.sharedPref),
        ),
      );
      showtoast();
      toastification.show(
        context: context,
        title: Text("Welcome ShopKeeper"),
        type: ToastificationType.success,
        style: ToastificationStyle.minimal,
        autoCloseDuration: const Duration(seconds: 7),
      );
    } else {
      toastification.show(
        context: context,
        title: Text("Account not approved please contact admin "),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  void forgetpass() async {
     showDialog(
      context: context,
      builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Reset Account",style: TextStyle(
                      color: Color.fromARGB(255, 9, 9, 9),
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Metropolis',
                    ),),
            content: Container(height: 100, child: Text("dummy",style: TextStyle(
                      color: Color.fromARGB(255, 9, 9, 9),
                      fontFamily: 'Metropolis',
                    ),)),
          );
        },
      );
    },
     );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              color: Color.fromARGB(255, 248, 242, 241),
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.05),
                  const Text(
                    "Login To SpeedyBasket",
                    style: TextStyle(
                      color: Color.fromARGB(255, 9, 9, 9),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Metropolis',
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Container(
                    height: constraints.maxHeight * 0.35,
                    child: Image.asset('assets/login4.png'),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(constraints.maxWidth * 0.05),
                      child: Form(
                        key: loginformkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: emailcontroller1,
                              decoration: InputDecoration(
                                labelText: "Enter Email",
                                hintText: "abc@gmail.com",
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.black,
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field is Mandatory";
                                }
                              },
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            TextFormField(
                              obscureText: true,
                              controller: passcontroller1,
                              decoration: InputDecoration(
                                labelText: "Enter Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field is Mandatory";
                                }
                              },
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            Container(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (loginformkey.currentState!.validate()) {
                                    signin();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.all(15.0),
                                ),
                                icon: Icon(Icons.login),
                                label: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => signupuser(
                                            sharedPref: widget.sharedPref),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Don't Have an Account",
                                    style: TextStyle(
                                      fontFamily: 'Metropolis',
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    forgetpass();
                                  },
                                  child: Text(
                                    "Forgot Password/Email",
                                    style: TextStyle(
                                      fontFamily: 'Metropolis',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
