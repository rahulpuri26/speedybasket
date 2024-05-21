import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/logi2n.dart';
import 'package:speedy_basket/signupshop.dart';
import 'package:toastification/toastification.dart';

class signupuser extends StatefulWidget {
  final SharedPreferences sharedPref;
  signupuser({super.key, required this.sharedPref});

  @override
  State<signupuser> createState() => _signupuserState();
}

class _signupuserState extends State<signupuser> {
  TextEditingController emailcontroller1 = TextEditingController();
  TextEditingController passcontroller1 = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();

  final signupformkey = GlobalKey<FormState>();
  bool isverified = false;
  String status = 'Email Not Verified';
  bool emailsent = false;
  bool user = false;
  Timer? timer;
  String myuserid = "";

  void initState() {
    bool? isLogged = widget.sharedPref.getBool("isLogged") ?? false;
    timer = Timer.periodic(Duration(seconds: 5), (_) {
      checkemailverified();
    });
    super.initState();
  }

  void checkemailverified() {
    setState(() {
      FirebaseAuth.instance.currentUser!.reload();
      bool ans = FirebaseAuth.instance.currentUser!.emailVerified;
      if (ans) {
        addtofirestore();
        toastification.show(
          context: context,
          title: Text("Email Verified Successfully!"),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 5),
        );

        status = "Verified";
        timer!.cancel();
      }
    });
  }

  void addtofirestore() async {
    await FirebaseFirestore.instance.collection("users").add({
      "email": emailcontroller1.text.trim(),
      "name": namecontroller.text,
      "password": passcontroller1.text.trim(),
      "phone": phonecontroller.text,
      "uid": myuserid,
      "role": "User",
      "status": ""
    });
  }

  void signup() async {
    try {
      print("called");
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailcontroller1.text, password: passcontroller1.text);

      if (userCredential.user!.uid != null &&
          userCredential.user!.uid.isNotEmpty) {
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
        myuserid = userCredential.user!.uid.toString();
        toastification.show(
          context: context,
          title: Text("Email Sent Successfully!"),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 5),
        );

        setState(() {
          emailsent = true;
          user = true;
        });
        print(userCredential.user!.uid);
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: Text(e.toString()),
        type: ToastificationType.warning,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Color.fromARGB(
                255, 248, 242, 241), 
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                const Text(
                  "Sign Up to Speedy Basket",
                  style: TextStyle(
                    color: Color.fromARGB(255, 9, 9, 9),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Metropolis',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 280,
                  child: Image.asset('assets/signup.png'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: signupformkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16.0),
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
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: namecontroller,
                              decoration: InputDecoration(
                                labelText: "Name",
                                prefixIcon: Icon(
                                  Icons.abc,
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
                            SizedBox(height: 16.0),
                            TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: phonecontroller,
                              decoration: InputDecoration(
                                labelText: "Phone No.",
                                prefixIcon: Icon(
                                  Icons.phone,
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
                            const SizedBox(height: 16.0),
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
                            SizedBox(height: 16.0),
                            Container(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    signup();
                                    if (signupformkey.currentState!
                                        .validate()) {}
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 8, 8, 8),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.all(15.0)),
                                  icon: Icon(Icons.app_registration_sharp),
                                  label: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontFamily: 'Metropolis',
                                    ),
                                  )),
                            ),
                            const SizedBox(height: 20.0),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => log2in(
                                              sharedPref: widget.sharedPref)));
                                },
                                child: Text(
                                  "Already have an account ",
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                  ),
                                )),
                            const SizedBox(height: 10.0),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => signupshop(
                                              sharedPref: widget.sharedPref)));
                                },
                                child: Text(
                                  "Sign Up as a Shopkeeper ",
                                  style: TextStyle(
                                    fontFamily: 'Metropolis',
                                  ),
                                )),
                            SizedBox(
                              height: 70,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
