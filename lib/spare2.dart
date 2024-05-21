// // @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //         home: Scaffold(
// //       body: Container(
// //         child: Form(
// //             key: loginformkey,
// //             child: Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     const Text(
// //                       "Login To SpeedyBasket",
// //                       style: TextStyle(
// //                         color: Color.fromARGB(255, 9, 9, 9),
// //                         fontSize: 44.0,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     const SizedBox(
// //                       height: 44.0,
// //                     ),
// //                     TextFormField(
// //                         controller: emailcontroller1,
// //                         decoration: const InputDecoration(
// //                             labelText: "Enter Email",
// //                             hintText: "abc@gmail.com",
// //                             prefixIcon: Icon(
// //                               Icons.mail,
// //                               color: Colors.black,
// //                             )),
// //                         validator: (value) {
// //                           if (value!.isEmpty) {
// //                             return "Field is Mandatory";
// //                           }
// //                         }),
// //                     const SizedBox(
// //                       height: 26.0,
// //                     ),
// //                     TextFormField(
// //                         obscureText: true,
// //                         controller: passcontroller1,
// //                         decoration: const InputDecoration(
// //                             labelText: "Enter Password",
// //                             hintText: "",
// //                             prefixIcon: Icon(
// //                               Icons.lock,
// //                               color: Colors.black,
// //                             )),
// //                         validator: (value) {
// //                           if (value!.isEmpty) {
// //                             return "Field is Mandatory";
// //                           }
// //                         }),
// //                     const SizedBox(
// //                       height: 50.0,
// //                     ),
// //                     Container(
// //                       width: double.infinity,
// //                       child: ElevatedButton.icon(
// //                           onPressed: () {
// //                             if (loginformkey.currentState!.validate()) {
// //                               signin();
// //                             }
// //                           },
// //                           style: ElevatedButton.styleFrom(
// //                               backgroundColor: Colors.black,
// //                               foregroundColor: Colors.white,
// //                               padding: EdgeInsets.all(15.0)),
// //                           icon: Icon(Icons.login),
// //                           label: Text("Login")),
// //                     ),
// //                     const SizedBox(height: 20.0),
// //                     TextButton(
// //                       onPressed: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (_) =>
// //                                 signup(sharedPref: widget.sharedPref),
// //                           ),
// //                         );
// //                       },
// //                       child: Text("Don't Have an Account"),
// //                     )
// //                   ],
// //                 ))),
// //       ),
// //     ));
// //   }
// // }






// onPressed: () {
//                                 signup();
//                                 if (signupformkey.currentState!.validate()) {}
//                               },
