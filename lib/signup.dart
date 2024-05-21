import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/logi2n.dart';
import 'package:toastification/toastification.dart';

class signup extends StatefulWidget {
  final SharedPreferences sharedPref;
  signup({super.key, required this.sharedPref});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> with TickerProviderStateMixin {
  TextEditingController emailcontroller1 = TextEditingController();
  TextEditingController passcontroller1 = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController nameshopcontroller = TextEditingController();
  TextEditingController shopnamecontroller = TextEditingController();
  TextEditingController gstcontroller = TextEditingController();
  TextEditingController shopemailcontroller = TextEditingController();
  TextEditingController spasscontroller = TextEditingController();
  TextEditingController shopephonecontroller = TextEditingController();
  final signupformkey = GlobalKey<FormState>();
  final signupshopformkey = GlobalKey<FormState>();

  bool isverified = false;
  String status = 'Email Not Verified';
  bool emailsent = false;
  bool emailsentshop = false;
  Timer? timer;
  String myuserid = "";
  TabController? _tabController;
  bool user = false;
  void initState() {
    bool? isLogged = widget.sharedPref.getBool("isLogged") ?? false;

    _tabController = TabController(length: 2, vsync: this);

    timer = Timer.periodic(Duration(seconds: 5), (_) {
      if (emailsentshop == true) {
        checkshopemailverified();
      } else {
        checkemailverified();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
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
      body: Container(
        child: Column(
          children: [
            Container(
              child: TabBar(controller: _tabController, tabs: const [
                Tab(text: "Sign Up as User ", icon: Icon(Icons.person)),
                Tab(text: "Sign Up as ShopKeeper", icon: Icon(Icons.house)),
              ]),
            ),
             TabBarView(controller: _tabController, children: [
              Form(
                key: signupformkey,
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sign Up to Speedy Basket",
                          style: TextStyle(
                            color: Color.fromARGB(255, 8, 8, 8),
                            fontSize: 44.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 44.0,
                        ),
                        TextFormField(
                            controller: emailcontroller1,
                            decoration: const InputDecoration(
                                labelText: "Enter Email",
                                hintText: "abc@gmail.com",
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.black,
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Field is Mandatory";
                              }
                            }),
                        const SizedBox(
                          height: 20.0,
                        ),
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
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Field is Mandatory";
                              }
                            }),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                            controller: namecontroller,
                            decoration: InputDecoration(
                                labelText: "Name",
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Field is Mandatory";
                              }
                            }),
                        const SizedBox(height: 20.0),
                        TextFormField(
                            controller: passcontroller1,
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: Colors.black,
                                )),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Field is Mandatory";
                              }
                            }),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                signup();
                                if (signupformkey.currentState!.validate()) {}
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 29, 153, 33),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.all(15.0)),
                              icon: Icon(Icons.app_registration_sharp),
                              label: Text("Sign Up")),
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
                            child: Text("Already have an account "))
                      ],
                    )),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                              key: signupshopformkey,
                              child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Sign Up to Speedy Basket as Shopkeeper",
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 8, 8, 8),
                                          fontSize: 44.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 44.0,
                                      ),
                                      TextFormField(
                                          controller: shopemailcontroller,
                                          decoration: const InputDecoration(
                                              labelText: "Enter Email",
                                              hintText: "abc@gmail.com",
                                              prefixIcon: Icon(
                                                Icons.mail,
                                                color: Colors.black,
                                              )),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Field is Mandatory";
                                            }
                                          }),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      TextFormField(
                                          controller: shopnamecontroller,
                                          decoration: const InputDecoration(
                                              labelText: "Enter shop Name",
                                              prefixIcon: Icon(
                                                Icons.shop_rounded,
                                                color: Colors.black,
                                              )),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Field is Mandatory";
                                            }
                                          }),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      TextFormField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          controller: shopephonecontroller,
                                          decoration: InputDecoration(
                                              labelText: "Phone No.",
                                              prefixIcon: Icon(
                                                Icons.phone,
                                                color: Colors.black,
                                              )),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Field is Mandatory";
                                            }
                                          }),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      TextFormField(
                                          controller: nameshopcontroller,
                                          decoration: InputDecoration(
                                              labelText: "Name",
                                              prefixIcon: Icon(
                                                Icons.person,
                                                color: Colors.black,
                                              )),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Field is Mandatory";
                                            }
                                          }),
                                      const SizedBox(height: 20.0),
                                      TextFormField(
                                          controller: spasscontroller,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                              labelText: "Password",
                                              prefixIcon: Icon(
                                                Icons.password,
                                                color: Colors.black,
                                              )),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Field is Mandatory";
                                            }
                                          }),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                          controller: gstcontroller,
                                          decoration: const InputDecoration(
                                              labelText: "Enter Gst",
                                              hintText: "Registered GSTIN ",
                                              prefixIcon: Icon(
                                                Icons.numbers,
                                                color: Colors.black,
                                              )),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Field is Mandatory";
                                            }
                                          }),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                            onPressed: () {
                                              signupshop();
                                              if (signupshopformkey
                                                  .currentState!
                                                  .validate()) {}
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 29, 153, 33),
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.all(15.0)),
                                            icon: Icon(
                                                Icons.app_registration_sharp),
                                            label:
                                                Text("Sign Up as ShopKeeper")),
                                      ),
                                      const SizedBox(height: 20.0),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => log2in(
                                                        sharedPref: widget
                                                            .sharedPref)));
                                          },
                                          child:
                                              Text("Already have an account "))
                                    ],
                                  ))))))
            ])
          ],
        ),
      ),
    ));
  }
}
