// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:speedy_basket/logi2n.dart';
// import 'package:speedy_basket/signupshop.dart';
// import 'package:toastification/toastification.dart';

// class spare3 extends StatefulWidget {
//   final SharedPreferences sharedPref;
//   spare3({super.key, required this.sharedPref});

//   @override
//   State<spare3> createState() => _spare3State();
// }

// class _spare3State extends State<spare3> {
//   TextEditingController emailcontroller1 = TextEditingController();
//   TextEditingController passcontroller1 = TextEditingController();
//   TextEditingController namecontroller = TextEditingController();
//   TextEditingController phonecontroller = TextEditingController();

//   final signupformkey = GlobalKey<FormState>();
//   bool isverified = false;
//   String status = 'Email Not Verified';
//   bool emailsent = false;
//   bool user = false;
//   Timer? timer;
//   String myuserid = "";
//   bool passwordIsValid = false;
//   bool isButtonPressed = false;

//   @override
//   void initState() {
//     super.initState();
//     bool? isLogged = widget.sharedPref.getBool("isLogged") ?? false;
//     timer = Timer.periodic(Duration(seconds: 5), (_) {
//       checkemailverified();
//     });
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
//       "email": emailcontroller1.text.trim(),
//       "name": namecontroller.text,
//       "password": passcontroller1.text.trim(),
//       "phone": phonecontroller.text,
//       "uid": myuserid,
//       "role": "User",
//       "status": ""
//     });
//   }

//   void signup() async {
//     setState(() {
//       isButtonPressed = true;
//     });

//     if (signupformkey.currentState!.validate() && passwordIsValid) {
//       try {
//         print("called");
//         UserCredential userCredential = await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(
//                 email: emailcontroller1.text, password: passcontroller1.text);

//         if (userCredential.user!.uid != null &&
//             userCredential.user!.uid.isNotEmpty) {
//           await FirebaseAuth.instance.currentUser!.sendEmailVerification();
//           myuserid = userCredential.user!.uid.toString();
//           toastification.show(
//             context: context,
//             title: Text("Email Sent Successfully!"),
//             type: ToastificationType.success,
//             style: ToastificationStyle.fillColored,
//             autoCloseDuration: const Duration(seconds: 5),
//           );

//           setState(() {
//             emailsent = true;
//             user = true;
//           });
//           print(userCredential.user!.uid);
//         }
//       } catch (e) {
//         toastification.show(
//           context: context,
//           title: Text(e.toString()),
//           type: ToastificationType.warning,
//           style: ToastificationStyle.fillColored,
//           autoCloseDuration: const Duration(seconds: 5),
//         );
//       }
//     }
//   }

//   String? passwordValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       if (isButtonPressed) {
//         return "Field is Mandatory";
//       }
//       return null;
//     } else if (value.length < 8) {
//       return "Password must be at least 8 characters long";
//     } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
//       return "Password must contain at least one uppercase letter";
//     } else if (!RegExp(r'[a-z]').hasMatch(value)) {
//       return "Password must contain at least one lowercase letter";
//     } else if (!RegExp(r'[0-9]').hasMatch(value)) {
//       return "Password must contain at least one digit";
//     } else if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
//       return "Password must contain at least one special character";
//     }
//     return null;
//   }

//   void validatePassword(String value) {
//     setState(() {
//       passwordIsValid = passwordValidator(value) == null;
//     });
//   }

//   @override
//   void dispose() {
//     timer!.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: SingleChildScrollView(
//           child: Container(
//             color: Color.fromARGB(255, 248, 242, 241), // Set your desired background color here
//             child: Column(
//               children: [
//                 SizedBox(height: 50,),
//                 const Text(
//                   "Sign Up to Speedy Basket",
//                   style: TextStyle(
//                     color: Color.fromARGB(255, 9, 9, 9),
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Metropolis',
//                   ),
//                 ),
//                 SizedBox(height: 20,),
//                 Container(
//                   height: 280,
//                   child: Image.asset('assets/signup.png'),
//                 ),
                
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Form(
//                         key: signupformkey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 16.0),
//                             TextFormField(
//                               controller: emailcontroller1,
//                               decoration: InputDecoration(
//                                 labelText: "Enter Email",
//                                 hintText: "abc@gmail.com",
//                                 prefixIcon: Icon(
//                                   Icons.mail,
//                                   color: Colors.black,
//                                 ),
//                                 filled: true,
//                                 fillColor: Colors.grey.withOpacity(0.2),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(25.0),
//                                 ),
//                               ),
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   if (isButtonPressed) {
//                                     return "Field is Mandatory";
//                                   }
//                                 }
//                               },
//                               style: TextStyle(
//                                 fontFamily: 'Metropolis',
//                               ),
//                             ),
//                              SizedBox(height: 16.0),
//                             TextFormField(
//                             controller: namecontroller,
//                             decoration: InputDecoration(
//                                 labelText: "Name",
//                                 prefixIcon: Icon(
//                                   Icons.abc,
//                                   color: Colors.black,
//                                 ),filled: true,
//                                 fillColor: Colors.grey.withOpacity(0.2),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(25.0),
//                                 ),
//                               ),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 if (isButtonPressed) {
//                                   return "Field is Mandatory";
//                                 }
//                               }
//                             },
//                             style: TextStyle(
//                                 fontFamily: 'Metropolis',
//                               ),
//                             ),
//                             SizedBox(height: 16.0),
//                             TextFormField(
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly
//                             ],
//                             controller: phonecontroller,
//                             decoration: InputDecoration(
//                                 labelText: "Phone No.",
//                                 prefixIcon: Icon(
//                                   Icons.phone,
//                                   color: Colors.black,
//                                 ),filled: true,
//                                 fillColor: Colors.grey.withOpacity(0.2),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(25.0),
//                                 ),
//                               ),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 if (isButtonPressed) {
//                                   return "Field is Mandatory";
//                                 }
//                               }
//                             },
//                             style: TextStyle(
//                                 fontFamily: 'Metropolis',
//                               ),
//                             ),
//                             const SizedBox(height: 16.0),
//                             TextFormField(
//                               onChanged: validatePassword,
//                               obscureText: true,
//                               controller: passcontroller1,
//                               decoration: InputDecoration(
//                                 labelText: "Enter Password",
//                                 prefixIcon: Icon(
//                                   Icons.lock,
//                                   color: Colors.black,
//                                 ),
//                                 filled: true,
//                                 fillColor: Colors.grey.withOpacity(0.2),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(25.0),
//                                 ),
//                                 errorText: !passwordIsValid ? passwordValidator(passcontroller1.text) : null,
//                               ),
//                               style: TextStyle(
//                                 fontFamily: 'Metropolis',
//                               ),
//                             ),
//                             SizedBox(height: 16.0),
//                             Container(
//                               width: double.infinity,
//                               height: 50,
//                               child: ElevatedButton.icon(
//                                 onPressed: () {
//                                   signup();
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Color.fromARGB(255, 8, 8, 8),
//                                   foregroundColor: Colors.white,
//                                   padding: EdgeInsets.all(15.0),
//                                 ),
//                                 icon: Icon(Icons.app_registration_sharp),
//                                 label: Text(
//                                   "Sign Up",
//                                   style: TextStyle(
//                                     fontFamily: 'Metropolis',
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 20.0),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => log2in(sharedPref: widget.sharedPref),
//                                   ),
//                                 );
//                               },
//                               child: Text(
//                                 "Already have an account ",
//                                 style: TextStyle(
//                                   fontFamily: 'Metropolis',
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 10.0),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => signupshop(sharedPref: widget.sharedPref),
//                                   ),
//                                 );
//                               },
//                               child: Text(
//                                 "Sign Up as a Shopkeeper ",
//                                 style: TextStyle(
//                                   fontFamily: 'Metropolis',
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 100,),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

                           
