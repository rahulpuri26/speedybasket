// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:speedy_basket/logi2n.dart';
// import 'package:speedy_basket/login.dart';
// import 'package:toastification/toastification.dart';

// class Practice extends StatefulWidget {
//   final SharedPreferences sharedPref;
//   Practice({super.key, required this.sharedPref});

//   @override
//   State<Practice> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<Practice> with TickerProviderStateMixin {
//   TabController? _tabController;
//   Timer? timer;
//   TextEditingController emailcontroller1 = TextEditingController();
//   TextEditingController passcontroller1 = TextEditingController();
//   //signup
//   TextEditingController namecontroller = TextEditingController();
//   TextEditingController emailcontroller2 = TextEditingController();
//   TextEditingController passcontroller2 = TextEditingController();
//   TextEditingController phonecontroller = TextEditingController();
//   bool isverified = false;
//   String status = 'Email Not Verified';
//   bool emailsent = false;
//   String myuserid = "";

//   final loginformkey = GlobalKey<FormState>();
//   final signupformkey = GlobalKey<FormState>();
//   @override
//   void initState() {
//     bool? isLogged = widget.sharedPref.getBool("isLogged") ?? false;

//     _tabController = TabController(length: 2, vsync: this);

//     timer = Timer.periodic(Duration(seconds: 5), (_) {
//       if (emailsent == true) {
//         checkemailverified();
//       }
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     timer!.cancel();
//     super.dispose();
//   }

//   void checkemailverified() {
//     setState(() {
//       FirebaseAuth.instance.currentUser!.reload();
//       bool ans = FirebaseAuth.instance.currentUser!.emailVerified;
//       if (ans) {
//         addtofirestore();
//         toastification.show(
//           context: context,
//           title: Text("Email Verified Successfully!"),
//           type: ToastificationType.success,
//           style: ToastificationStyle.fillColored,
//           autoCloseDuration: const Duration(seconds: 5),
//         );

//         status = "Verified";
//         timer!.cancel();
//       }
//     });
//   }

//   void addtofirestore() async {
//     await FirebaseFirestore.instance.collection("users").add({
//       "email": emailcontroller2.text.trim(),
//       "name": namecontroller.text,
//       "password": passcontroller2.text.trim(),
//       "phone": phonecontroller.text,
//       "uid": myuserid,
//     });
//   }

//   void signup() async {
//     try {
//       print("called");
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(
//               email: emailcontroller2.text, password: passcontroller2.text);

//       if (userCredential.user!.uid != null &&
//           userCredential.user!.uid.isNotEmpty) {
//         await FirebaseAuth.instance.currentUser!.sendEmailVerification();
//         myuserid = userCredential.user!.uid.toString();
//         toastification.show(
//           context: context,
//           title: Text("Email Sent Successfully!"),
//           type: ToastificationType.success,
//           style: ToastificationStyle.fillColored,
//           autoCloseDuration: const Duration(seconds: 5),
//         );

//         setState(() {
//           emailsent = true;
//         });
//         print(userCredential.user!.uid);
//       }
//     } catch (e) {
//       toastification.show(
//         context: context,
//         title: Text(e.toString()),
//         type: ToastificationType.warning,
//         style: ToastificationStyle.fillColored,
//         autoCloseDuration: const Duration(seconds: 5),
//       );
//     }
//   }

//   List<dynamic> al = [];

//   Future<void> signin() async {
//     UserCredential loginCredential = await FirebaseAuth.instance
//         .signInWithEmailAndPassword(
//             email: emailcontroller1.text, password: passcontroller1.text);
//     String mid = loginCredential.user!.uid.toString();

//     if (mid != null && mid.isNotEmpty) {
//       CollectionReference category =
//           FirebaseFirestore.instance.collection("users");
//       QuerySnapshot snapshot =
//           await category.where("uid", isEqualTo: mid).get();
//       for (var data in snapshot.docs) {
//         // get all data
//         String email = data["email"];
//         String name = data["name"];
//         String password = data["password"];
//         String phone = data["phone"];
//         String uid = data["uid"];
//         al.add(email);
//         al.add(name);
//         al.add(password);
//         al.add(phone);
//         al.add(uid);
//       }
//       print(al);
//       toastification.show(
//         context: context,
//         title: Text("Logged In Succesfully"),
//         type: ToastificationType.success,
//         style: ToastificationStyle.fillColored,
//         autoCloseDuration: const Duration(seconds: 5),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "",
//       home: Scaffold(
//           body: Column(
//         children: [
//           Container(
//               height: 180,
//               width: MediaQuery.sizeOf(context).width,
//               // decoration: BoxDecoration(
//               //     image:
//               //         DecorationImage(image: AssetImage(''), fit: BoxFit.fill),
//               //     borderRadius: BorderRadius.only(
//               //       bottomLeft: Radius.circular(40),
//               //       bottomRight: Radius.circular(40),
//               //     )),
//               child: Text(
//                 "  HEADER",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                 ),
//               )),
//           Container(
//             child: TabBar(controller: _tabController, tabs: const [
//               Tab(text: "Login", icon: Icon(Icons.login)),
//               Tab(text: "Sign Up", icon: Icon(Icons.app_registration)),
//             ]),
//           ),
//           Expanded(
//               child: Container(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(20.0),
//                   //login

//                   child: SingleChildScrollView(
//                     child: Form(
//                       key: loginformkey,
//                       child: Column(
//                         children: [
//                           TextFormField(
//                               controller: emailcontroller1,
//                               decoration: InputDecoration(
//                                 labelText: "Enter Email",
//                                 hintText: "abc@gmail.com",
//                               ),
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return "Field is Mandatory";
//                                 }
//                               }),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           TextFormField(
//                               obscureText: true,
//                               controller: passcontroller1,
//                               decoration: InputDecoration(
//                                 labelText: "Enter Password",
//                                 hintText: "",
//                               ),
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return "Field is Mandatory";
//                                 }
//                               }),
//                           SizedBox(
//                             height: 30,
//                           ),
//                           Center(
//                             child: ElevatedButton.icon(
//                                 onPressed: () {
//                                   if (loginformkey.currentState!.validate()) {
//                                     signin();
//                                   }
//                                   Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (_) => log2in()));
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.blue[300],
//                                     foregroundColor: Colors.white,
//                                     padding: EdgeInsets.all(15.0)),
//                                 icon: Icon(Icons.login),
//                                 label: Text("Login")),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

//                 //signup
//                 Expanded(
//                     child: SingleChildScrollView(
//                         child: Padding(
//                             padding: EdgeInsets.all(20.0),
//                             child: Form(
//                               key: signupformkey,
//                               child: Column(
//                                 children: [
//                                   TextFormField(
//                                       controller: namecontroller,
//                                       decoration:
//                                           InputDecoration(labelText: "Name"),
//                                       validator: (value) {
//                                         if (value!.isEmpty) {
//                                           return "Field is Mandatory";
//                                         }
//                                       }),
//                                   TextFormField(
//                                       inputFormatters: [
//                                         FilteringTextInputFormatter.digitsOnly
//                                       ],
//                                       controller: phonecontroller,
//                                       decoration: InputDecoration(
//                                           labelText: "Phone No."),
//                                       validator: (value) {
//                                         if (value!.isEmpty) {
//                                           return "Field is Mandatory";
//                                         }
//                                       }),
//                                   TextFormField(
//                                       controller: emailcontroller2,
//                                       decoration:
//                                           InputDecoration(labelText: "Email"),
//                                       validator: (value) {
//                                         if (value!.isEmpty) {
//                                           return "Field is Mandatory";
//                                         }
//                                       }),
//                                   TextFormField(
//                                       controller: passcontroller2,
//                                       obscureText: true,
//                                       decoration: InputDecoration(
//                                           labelText: "Password"),
//                                       validator: (value) {
//                                         if (value!.isEmpty) {
//                                           return "Field is Mandatory";
//                                         }
//                                       }),
//                                   SizedBox(
//                                     height: 30,
//                                   ),
//                                   Center(
//                                     child: ElevatedButton.icon(
//                                         onPressed: () {
//                                           signup();
//                                           if (signupformkey.currentState!
//                                               .validate()) {}
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.blue[300],
//                                             foregroundColor: Colors.white,
//                                             padding: EdgeInsets.all(15.0)),
//                                         icon: Icon(Icons.app_registration),
//                                         label: Text("Sign Up")),
//                                   )
//                                 ],
//                               ),
//                             ))))
//               ],
//             ),
//           ))
//         ],
//       )),
//     );
//   }
// }
