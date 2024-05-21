// // //  // final Response = await FirebaseFirestore.instance
// // //       //     .collection("users")
// // //       //     .where({"uid": mid});
// // //       FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: mid)
// // //     .snapshots().listen(
// // //           (data) => print('name ${data.docs[0]['name']}')
// // //     );
// // //     toastification.show(
// // //           context: context,
// // //           title: Text("Logged In Succesfully"),
// // //           type: ToastificationType.success,
// // //           style: ToastificationStyle.fillColored,
// // //           autoCloseDuration: const Duration(seconds: 5),
// // //         );


// // TextFormField(
// //                                       controller: namecontroller,
// //                                       decoration:
// //                                           InputDecoration(labelText: "Name"),
// //                                       validator: (value) {
// //                                         if (value!.isEmpty) {
// //                                           return "Field is Mandatory";
// //                                         }
// //                                       }),
// //                                   TextFormField(
// //                                       inputFormatters: [
// //                                         FilteringTextInputFormatter.digitsOnly
// //                                       ],
// //                                       controller: phonecontroller,
// //                                       decoration: InputDecoration(
// //                                           labelText: "Phone No."),
// //                                       validator: (value) {
// //                                         if (value!.isEmpty) {
// //                                           return "Field is Mandatory";
// //                                         }
// //                                       }),
// //                                   TextFormField(
// //                                       controller: emailcontroller1,
// //                                       decoration:
// //                                           InputDecoration(labelText: "Email"),
// //                                       validator: (value) {
// //                                         if (value!.isEmpty) {
// //                                           return "Field is Mandatory";
// //                                         }
// //                                       }),
// //                                   // TextFormField(
// //                                   //     controller: passcontroller1,
// //                                   //     obscureText: true,
// //                                   //     decoration: InputDecoration(
// //                                   //         labelText: "Password"),
// //                                   //     validator: (value) {
// //                                   //       if (value!.isEmpty) {
// //                                   //         return "Field is Mandatory";
// //                                   //       }
// //                                   //     }),
// //                                   // SizedBox(
// //                                   //   height: 30,
// //                                   // ),
// //                                   // Center(
// //                                   //   child: ElevatedButton.icon(
// //                                   //       onPressed: () {
// //                                   //         signup();
// //                                   //         if (signupformkey.currentState!
// //                                   //             .validate()) {}
// //                                   //       },
// //                                   //       style: ElevatedButton.styleFrom(
// //                                   //           backgroundColor: Colors.blue[300],
// //                                   //           foregroundColor: Colors.white,
// //                                   //           padding: EdgeInsets.all(15.0)),
// //                                   //       icon: Icon(Icons.app_registration),
// //                                   //       label: Text("Sign Up")),
// //                                   // )

// // child: ElevatedButton.icon(
// //                                         onPressed: () {
// //                                           signup();
// //                                           if (signupformkey.currentState!
// //                                               .validate()) {
// //                                               }
// //                                         },
// //                                         style: ElevatedButton.styleFrom(
// //                                             backgroundColor: Colors.blue[300],
// //                                             foregroundColor: Colors.white,
// //                                             padding: EdgeInsets.all(15.0)),
// //                                         icon: Icon(Icons.app_registration),
// //                                         label: Text("Sign Up")),

// if (isLogin == true) {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => CatgMst(),
//             ));
//       } else {
//         toastification.show(
//           context: context,
//           title: Text("Wrong Credentials Please Sign Up or Reset your Account"),
//           type: ToastificationType.error,
//           style: ToastificationStyle.fillColored,
//           autoCloseDuration: const Duration(seconds: 5),
//         );
//       }


/*
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speedy_basket/mycategory.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class CatgMst extends StatefulWidget {
  const CatgMst({super.key});

  @override
  State<CatgMst> createState() => _CatgMstState();
}

class _CatgMstState extends State<CatgMst> {
   PlatformFile? selectedFile;
  bool isSelected = false;
  File? myImage;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController descontroller = TextEditingController();
 bool isedit=false;


 void uploadtoStorage() async {
    try {
      final ref =
          await FirebaseStorage.instance.ref("category").child(selectedFile!.name!);

      ref.putData(selectedFile!.bytes!);

      final token = await ref.getDownloadURL();
      print(token);
    } catch (e) {
      print(e);
    }
  }

  void pickFilesforOthers(ImageSource source) async {
    final pickedresult = await ImagePicker().pickImage(source: source);

    if (pickedresult != null) {
      setState(() {
        myImage = File(pickedresult.path);
        isSelected = true;
      });
    }
  }

  void pickFilesForWeb() async {
    FilePickerResult? pickedresult =
        await FilePicker.platform.pickFiles(type: FileType.any);

    if (pickedresult != null) {
      setState(() {
        selectedFile = pickedresult.files.first;
        isSelected = true;
        uploadtoStorage();
      });
    }
  }
  List<MyCategory> al=[];
  final catgformkey = GlobalKey<FormState>();
  void showalert() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add Category"),
            content: Container(
              height: 200,
              child: Form(
                  key: catgformkey,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: namecontroller,
                          decoration: InputDecoration(
                              labelText: "Category Name",
                              hintText: "Category Name"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field is Mandatory";
                            }
                          }),
                      TextFormField(
                          controller: descontroller,
                          decoration: InputDecoration(
                              labelText: "Description",
                              hintText: "Description"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field is Mandatory";
                            }
                          }),
                          Column(
                            children: [
                              (kIsWeb)
            ? (isSelected)
                ? CircleAvatar(
                    maxRadius: 100,
                    backgroundImage:
                        MemoryImage(Uint8List.fromList(selectedFile!.bytes!)),
                  )
                : Text("no Image Selected")
            : (isSelected)
                ? CircleAvatar(
                    maxRadius: 100, backgroundImage: FileImage(myImage!))
                : Text("no Image Selected"),
        (kIsWeb)
            ? ElevatedButton(
                onPressed: () {
                  pickFilesForWeb();
                },
                child: Text("File for Web"))
            : Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        pickFilesforOthers(ImageSource.camera);
                      },
                      child: Text("File from Camera")),
                  const SizedBox(
                    width: 20,
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        pickFilesforOthers(ImageSource.gallery);
                      },
                      child: Text("File from Gallery"))
                ],
              )
                            ],
                          )
                    ],
                  )),
            ),
            actions: [
              ElevatedButton.icon(
                  onPressed: () {
                    adddata();
                  },
                  icon: Icon(Icons.check_circle),
                  label: Text("Save")),
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel),
                  label: Text("Close")),
            ],
          );
        });
  }

  void adddata() async {
    await FirebaseFirestore.instance.collection("categories").add({
      "catgname": namecontroller.text.trim(),
      "catgdes": descontroller.text.trim(),
      "pic": "",
    });

    namecontroller.text = "";
    descontroller.text = "";
  }

void fetchdata() async
{
al.clear();

final Response= await FirebaseFirestore.instance.collection("categories").get();
setState(() {
  if (Response.docs.isNotEmpty)
{
for (var data in Response.docs)
{

String name = data["catgname"];
String  des = data["catgdes"];
String  pic = data["pic"];

al.add(MyCategory(name, des, pic));

}

}
});

}
@override
  void initState() {
   fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "",
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showalert();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Column(
          children: [
            Expanded(
                child: ListView(
              children: [

for (int i=0;i<al.length;i++)

                ListTile(
                  title: Text(al[i].name),
                  subtitle: Text(al[i].des),
                  trailing:   Row(
  mainAxisSize: MainAxisSize.min,
  children: [
     IconButton(onPressed: (){
setState(() {
  isedit=true;
  namecontroller.text =al[i].name.toString();
  descontroller.text =al[i].des.toString();
  
});
     }, icon: Icon(Icons.edit)),
      
      IconButton(onPressed: (){

      showalert();
  

      }, icon: Icon(Icons.delete))
  ],

  ),
                 
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}

Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                for (int i = 0; i < al.length; i++)
                  ListTile(
                    title: Text(al[i].name),
                    subtitle: Text(al[i].des),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isedit = true;
                              namecontroller.text = al[i].name;
                              descontroller.text = al[i].des;
                              mydocid = al[i].docid;
                              showalert();
                            });
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            mydocid = al[i].docid;
                            delete();
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  )
              ],
            )),
          ],
        )








        Code for sub cat


        import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speedy_basket/mycategory.dart';
import 'package:speedy_basket/subcategory.dart';

class subcat extends StatefulWidget {
  const subcat({super.key});

  @override
  State<subcat> createState() => _subcatState();
}

class _subcatState extends State<subcat> {
  @override
  TextEditingController namecontroller = TextEditingController();
  TextEditingController descontroller = TextEditingController();
  bool isedit = false;
  String mydocid = "";
  List<subCategory> al = [];
  final catgformkey = GlobalKey<FormState>();
  String selectedValue = '';

  String Category = "Add Sub Category";

  void showalert() {
    if (isedit) {
      setState(() {
        Category = "Modify Sub Category";
      });
    } else {
      setState(() {
        Category = "Add Sub Category";
      });
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(Category),
            content: Container(
              height: 200,
              child: Form(
                  key: catgformkey,
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        items: al2.map((String value) {
                          return DropdownMenuItem<String>(
                            child: Text(value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          print('Selected value: $value');
                          setState(() {
                            selectedValue = value!;
                          });
                        },
                        value: selectedValue,
                      ),
                      TextFormField(
                          controller: namecontroller,
                          decoration: InputDecoration(
                              labelText: "Sub Category Name",
                              hintText: "Sub Category Name"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field is Mandatory";
                            }
                          }),
                      TextFormField(
                          controller: descontroller,
                          decoration: InputDecoration(
                              labelText: "Sub Category Description",
                              hintText: " Sub Category Description"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field is Mandatory";
                            }
                          }),
                    ],
                  )),
            ),
            actions: [
              ElevatedButton.icon(
                  onPressed: () {
                    if (isedit) {
                      update();
                    } else {
                      adddata();
                    }
                  },
                  icon: Icon(Icons.check_circle),
                  label: Text("Save")),
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel),
                  label: Text("Close")),
            ],
          );
        });
  }

  void adddata() async {
    await FirebaseFirestore.instance.collection("subcategories").add({
      "subcatgname": namecontroller.text.trim(),
      "subcatgdes": descontroller.text.trim(),
      "subcpic": "",
      "catgname": selectedValue
    });

    namecontroller.text = "";
    descontroller.text = "";
    fetchdata();
  }

  List<String> al2 = [];

  void getcat() async {
    final Response =
        await FirebaseFirestore.instance.collection("categories").get();
    setState(() {
      if (Response.docs.isNotEmpty) {
        for (var data in Response.docs) {
          String name = data["catgname"];
          al2.add(name);
          ;
        }
      }
    });
  }

  void fetchdata() async {
    al.clear();
    final Response =
        await FirebaseFirestore.instance.collection("subcategories").get();
    setState(() {
      if (Response.docs.isNotEmpty) {
        for (var data in Response.docs) {
          String name = data["subcatgname"];
          String desc = data["subcatgdes"];
          String pic = data["subcpic"];
          String mydocid = data.id;
          String category = data["categoryName"];
          al.add(subCategory(name, desc, pic, mydocid, category));
        }
      }
    });
  }

  void delete() async {
    await FirebaseFirestore.instance
        .collection("subcategories")
        .doc(mydocid)
        .delete();
    fetchdata();
  }

  void update() async {
    String subcatgname = namecontroller.text;
    String subcatgdes = descontroller.text;
    String subcpic = " ";
    String categoryName = "";

    await FirebaseFirestore.instance
        .collection("categories")
        .doc(mydocid)
        .update({
      "subcatgname": subcatgname,
      "subcatgdes": subcatgdes,
      "subcpic": subcpic,
      "categoryName" : categoryName
    });

    setState(() {
      isedit = false;
      namecontroller.text = "";
      descontroller.text = "";
      mydocid = "";
      fetchdata();
    });
  }

  @override
  void initState() {
    fetchdata();
    getcat();
    super.initState();
    selectedValue = 'SoftDrink';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "",
      home: Scaffold(
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            onPressed: () {
              showalert();
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ]),
        body: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                for (int i = 0; i < al.length; i++)
                  ListTile(
                    leading: Text(al2[i]),
                    title: Text(al[i].name),
                    subtitle: Text(al[i].desc),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isedit = true;
                              namecontroller.text = al[i].name;
                              descontroller.text = al[i].desc;
                              mydocid = al[i].id;
                              showalert();
                            });
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            mydocid = al[i].id;
                            delete();
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  )
              ],
            )),
          ],
        ),
      ),
    );
  }
}





shop controller 

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
                              backgroundColor: Color.fromARGB(255, 29, 153, 33),
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
                                  builder: (_) =>
                                      log2in(sharedPref: widget.sharedPref)));
                        },
                        child: Text("Already have an account "))
                  ],
                )))






                ////////////////\
                Form(
                  key: signupshopformkey,
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              controller: nameshopcontroller,
                              decoration: const InputDecoration(
                                  labelText: "Ente shop Name",
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
                                FilteringTextInputFormatter.digitsOnly
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
                                  if (signupshopformkey.currentState!
                                      .validate()) {}
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 29, 153, 33),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.all(15.0)),
                                icon: Icon(Icons.app_registration_sharp),
                                label: Text("Sign Up as ShopKeeper")),
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
                      )))






                       String name = data["catgname"];
          String des = data["catgdes"];
          String pic = data["pic"];
          String mydocid = data.id;
          al2.add(MyCategory(name, des, pic, mydocid));





          TextButton(
                        onPressed: () {
                          updateshopkeeper();
                        },
                        child: Text(al2[i].status))



/// this is for status not updating problem
                        setState(() {
    // Find the shopdata object with the given shopid in the local list
    int index = al2.indexWhere((element) => element.shopid == shopid);
    if (index != -1) {
      // Update the status of the shopdata object
      al2[index].status = newStatus;
    }
  });
}






















void checkrolefetch() async {
    al2.clear();
    final Response = await FirebaseFirestore.instance.collection("users").get();
    setState(() {
      if (Response.docs.isNotEmpty) {
        for (var data in Response.docs) {
          String status = data["status"];
          String role = data["role"];
          al2.add(userNavigation(status, role));
        }
      }
    });
  }







  void rolelogin() async {
    if (isLogin == true && role == "admin") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CatgMst(),
        ),
      );
    } else if (isLogin == true && role == "User") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => dummy(),
        ),
      );
    } else if (isLogin == true &&
        role == "ShopKeeper" &&
        status == "approved") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => dummy(),
        ),
      );
    } else {
      toastification.show(
        context: context,
        title: Text("Account not found please signup"),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }













  /////////////////////////
  ///Starting Container
  ///
  ///// Container(
            //   height: 180,
            //   width: MediaQuery.sizeOf(context).width,
            //   decoration: BoxDecoration(
            //       image:
            //           DecorationImage(image: AssetImage('assets/shopk.jpeg'), fit: BoxFit.fill),
            //       borderRadius: BorderRadius.only(
            //         bottomLeft: Radius.circular(40),
            //         bottomRight: Radius.circular(40),
            //       )),
            //   ),












            void initState() {
    fetchdata();
    getcat();
    super.initState();
  }
















   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showalert();
          },
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 5, // Reduced spacing
            mainAxisSpacing: 5, // Reduced spacing
          ),
          itemCount: al.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                // Add functionality for tapping on a grid item
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50, // Reduced height
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                              al[index].pic), // Assuming pic is a URL
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0), // Reduced padding
                      child: Text(
                        al[index].name,
                        style: TextStyle(
                          fontSize: 40, // Reduced font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2.0), // Reduced padding
                      child: Text(
                        'Price: \u20B9${al[index].price}',
                        style: TextStyle(
                          fontSize: 20, // Reduced font size
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2.0), // Reduced padding
                      child: Text(
                        'Special Price: \u20B9${al[index].sprice}',
                        style: TextStyle(
                          fontSize: 20, // Reduced font size
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2.0), // Reduced padding
                      child: Text(
                        'Quantity: ${al[index].quantity}',
                        style: TextStyle(
                          fontSize: 20, // Reduced font size
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}








 actions: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {},
            ),
          ],












import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/dummy.dart';
import 'package:speedy_basket/mycategory.dart';
import 'package:speedy_basket/prodclass.dart';

class userdashboard extends StatefulWidget {
  final SharedPreferences sharedPref;
  const userdashboard({super.key, required this.sharedPref});

  @override
  State<userdashboard> createState() => _userdashboardState();
}

class _userdashboardState extends State<userdashboard> {
  List<products> al = [];
  List<MyCategory> al2 = [];

  List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  void fetchdata() async {
    al.clear();
    final Response =
        await FirebaseFirestore.instance.collection("products").get();
    setState(() {
      if (Response.docs.isNotEmpty) {
        for (var data in Response.docs) {
          String name = data["productname"];
          String desc = data["productdes"];
          String quantity = data["productquan"];
          String pic = data["prodpic"];
          String price = data["price"];
          String sprice = data["specialprice"];
          String docid = data.id;
          String subcname = data["subcategoryName"];

          al.add(products(
              name, desc, pic, docid, price, sprice, quantity, subcname));
        }
      }
    });
  }

  void fetchcatdata() async {
    al2.clear();
    final Response =
        await FirebaseFirestore.instance.collection("categories").get();
    setState(() {
      if (Response.docs.isNotEmpty) {
        for (var data in Response.docs) {
          String name = data["catgname"];
          String des = data["catgdes"];
          String pic = data["pic"];
          String mydocid = data.id;

          al2.add(MyCategory(name, des, pic, mydocid));
          ;
        }
      }
    });
  }

  void initState() {
    fetchdata();
    fetchcatdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item,
                            fit: BoxFit.cover, width: 1000.0),
                      ],
                    )),
              ),
            ))
        .toList();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('14/10 B.K. Dutt  Gate'),
                    Text(
                      'Amritsar, Punjab, 143001',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => dummy()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search By Category',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {},
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                enlargeCenterPage: true,
                autoPlay: true,
              ),
              items: imageSliders,
            ),
            
            const Expanded(
              child: Text("Welcome to the App"),
            ),
          ],
        ),
      ),
    );
  }
}





@override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('14/10 B.K. Dutt  Gate'),
                    Text(
                      'Amritsar, Punjab, 143001',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => dummy()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search By Category',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {},
              ),
            ),
            SizedBox(
              height: 200, 
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imageUrls.length, 
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => dummy()),
                );
                    },
                    child: Card(
                      child: Container(
                        width:
                            350, 
                        height:
                            180, 
                        child: Image.asset(
                          imageUrls[index],fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Icon(
                Icons.category, 
                size: 30,
                color: Colors.black, 
              ),
              SizedBox(width: 10),
              Text(
                'Shop by Category',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
           Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, 
            mainAxisSpacing: 10, 
            crossAxisSpacing: 10, 
            childAspectRatio: 0.8,
          ),
          itemCount: al2.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Handle category tap
              },
              child: Card(
                color: Colors.black.withOpacity(0.3), 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      al2[index].pic,
                      width: 60, // Adjust image width
                      height: 60, // Adjust image height
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 5), 
                    Text(
                      al2[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12, 
                        color: Colors.white, 
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
  ],
),
      ),
    );
  }
}

*/