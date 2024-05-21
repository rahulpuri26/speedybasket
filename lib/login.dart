import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}


class _loginpageState extends State<loginpage> {
  final loginformkey = GlobalKey<FormState>();
  TextEditingController emailcontroller1 = TextEditingController();
  TextEditingController passcontroller1 = TextEditingController();

  List<dynamic> al = [];

  Future<void> signin() async {
    UserCredential loginCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailcontroller1.text, password: passcontroller1.text);
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
        al.add(email);
        al.add(name);
        al.add(password);
        al.add(phone);
        al.add(uid);
      }
      print(al);
      toastification.show(
        context: context,
        title: Text("Logged In Succesfully"),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Form(
              key: loginformkey,
              child: Column(
                children: [
                  TextFormField(
                      controller: emailcontroller1,
                      decoration: InputDecoration(
                        labelText: "Enter Email",
                        hintText: "abc@gmail.com",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is Mandatory";
                        }
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      obscureText: true,
                      controller: passcontroller1,
                      decoration: InputDecoration(
                        labelText: "Enter Password",
                        hintText: "",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is Mandatory";
                        }
                      }),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: ElevatedButton.icon(
                        onPressed: () {
                          if (loginformkey.currentState!.validate()) {
                             signin();
                             
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[300],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.all(15.0)),
                        icon: Icon(Icons.login),
                        label: Text("Login")),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
