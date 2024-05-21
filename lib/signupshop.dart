import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/logi2n.dart';
import 'package:speedy_basket/signupuser.dart';
import 'package:toastification/toastification.dart';

class signupshop extends StatefulWidget {
  final SharedPreferences sharedPref;
  signupshop({super.key, required this.sharedPref});

  @override
  State<signupshop> createState() => _signupshopState();
}

class _signupshopState extends State<signupshop> {
  TextEditingController nameshopcontroller = TextEditingController();
  TextEditingController shopnamecontroller = TextEditingController();
  TextEditingController gstcontroller = TextEditingController();
  TextEditingController shopemailcontroller = TextEditingController();
  TextEditingController spasscontroller = TextEditingController();
  TextEditingController shopephonecontroller = TextEditingController();
  final signupshopformkey = GlobalKey<FormState>();

   bool isverified = false;
  String status = 'Email Not Verified';
  bool emailsent = false;
  bool emailsentshop = false;
  Timer? timer;
  String myuserid = "";

   void initState() {
    bool? isLogged = widget.sharedPref.getBool("isLogged") ?? false;
     timer = Timer.periodic(Duration(seconds: 5), (_) {
      if (emailsentshop == true) {
        checkshopemailverified();
      }
    });
    super.initState();
  }
   void dispose() {
    timer!.cancel();
    super.dispose();
  }
  void checkshopemailverified() {
    setState(() {
      FirebaseAuth.instance.currentUser!.reload();
      bool ans = FirebaseAuth.instance.currentUser!.emailVerified;
      if (ans) {
        addshopkeeper();
        toastification.show(
          context: context,
          title: Text(
              "Email Verified Successfully! , Status Still Pending approval"),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 5),
        );

        status = "Verified";
        timer!.cancel();
      }
    });
  }
  void addshopkeeper() async {
    await FirebaseFirestore.instance.collection("users").add({
      "email": shopemailcontroller.text.trim(),
      "shopname ": shopnamecontroller.text,
      "name": nameshopcontroller.text,
      "password": spasscontroller.text.trim(),
      "phone": shopephonecontroller.text,
      "gst no ": gstcontroller.text,
      "uid": myuserid,
      "role": "ShopKeeper",
      "status": "pending"
    });
  }
  void signupshop() async {
    try {
      print("called");
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: shopemailcontroller.text, password: spasscontroller.text);

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
          emailsentshop = true;
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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Color.fromARGB(255, 248, 242, 241), // Set your desired background color here
            child: Column(
              children: [
                SizedBox(height: 50,),
                const Text(
                  "Sign Up as ShopKeeper",
                  style: TextStyle(
                    color: Color.fromARGB(255, 9, 9, 9),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Metropolis',
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 250,
                  child: Image.asset('assets/shopsign.png'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: signupshopformkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: nameshopcontroller,
                              decoration: InputDecoration(
                                labelText: "Username",
                                hintText: "Username",
                                prefixIcon: Icon(
                                  Icons.person,
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
                              controller: shopemailcontroller,
                              decoration: InputDecoration(
                                labelText: "Enter Shop Email",
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
                            controller: shopnamecontroller,
                            decoration: InputDecoration(
                                labelText: "Shop Name",
                                prefixIcon: Icon(
                                  Icons.abc,
                                  color: Colors.black,
                                ),filled: true,
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
                            controller: shopephonecontroller,
                            decoration: InputDecoration(
                                labelText: "Phone No.",
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.black,
                                ),filled: true,
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
                              controller: gstcontroller,
                              decoration: InputDecoration(
                                labelText: "Enter Gst Number",
                                prefixIcon: Icon(
                                  Icons.numbers,
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
                              controller: spasscontroller,
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
                          height:50,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                signupshop();
                                if (signupshopformkey.currentState!.validate()) {}
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 8, 8, 8),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.all(15.0)),
                              icon: Icon(Icons.app_registration_sharp),
                              label: Text("Sign Up",style: TextStyle(
                                    fontFamily: 'Metropolis',
                                  ),)),
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
                            child: Text("Already have an account ",style: TextStyle(
                                  fontFamily: 'Metropolis',
                                ),)),
                                const SizedBox(height: 10.0),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => signupuser(
                                          sharedPref: widget.sharedPref)));
                            },
                            child: Text("Sign Up as a User ",style: TextStyle(
                                  fontFamily: 'Metropolis',
                                ),)),
                               
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
