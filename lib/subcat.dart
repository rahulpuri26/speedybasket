import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/appdrawer.dart';
import 'package:speedy_basket/mycategory.dart';
import 'package:speedy_basket/subcategory.dart';

class subcat extends StatefulWidget {
  final SharedPreferences sharedPref;
  subcat({super.key, required this.sharedPref});

  @override
  State<subcat> createState() => _subcatState();
}

class _subcatState extends State<subcat> {
  @override
  TextEditingController namecontroller = TextEditingController();
  TextEditingController descontroller = TextEditingController();
  bool isedit = false;
  String mydocid = "";
  PlatformFile? selectedfile;
  bool isselected = false;
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
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(Category,style: TextStyle(
                      fontFamily: 'Metropolis',
                    ),),
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
                              hintText: "Sub Category Description"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field is Mandatory";
                            }
                          }),
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton.icon(
                    onPressed: () {
                      if (isedit == false) {
                        adddata();
                      } else {
                        update();
                        fetchdata();
                        mydocid = "";
                        Navigator.pop(context);
                      }
                    },
                    icon: Icon(Icons.check_circle),
                    label: Text("Save",style: TextStyle(
                      fontFamily: 'Metropolis',
                    ),)),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel),
                    label: Text("Close",style: TextStyle(
                      fontFamily: 'Metropolis',
                    ),)),
              ],
            );
          },
        );
      },
    );
  }

  void confirmation() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmation",style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontWeight: FontWeight.bold
                    ),),
            content: Text("Do You Want To Delete ?",style: TextStyle(
                      fontFamily: 'Metropolis',
                    ),),
            actions: [
              ElevatedButton.icon(
                  onPressed: () {
                    delete();
                  },
                  icon: Icon(Icons.check_circle),
                  label: Text("Yes",style: TextStyle(
                      fontFamily: 'Metropolis',
                    ),)),
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel),
                  label: Text("No",style: TextStyle(
                      fontFamily: 'Metropolis',
                    ),)),
            ],
          );
        });
  }

  void adddata() async {
    al.clear();
    await FirebaseFirestore.instance.collection("subcategories").add({
      "subcatgname": namecontroller.text.trim(),
      "subcatgdes": descontroller.text.trim(),
      "subcpic": "",
      "category": selectedValue
    });

    setState(() {
      namecontroller.text = "";
      descontroller.text = "";
      fetchdata();
      Category = " ";
    });
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
          String Mycategory = data["category"];
          al.add(subCategory(name, desc, pic, mydocid, Mycategory));
          ;
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
    String category = selectedValue;

    await FirebaseFirestore.instance
        .collection("subcategories")
        .doc(mydocid)
        .update({
      "subcatgname": subcatgname,
      "subcatgdes": subcatgdes,
      "subcpic": subcpic,
      "category": category
    });

    setState(() {
      isedit = false;
      namecontroller.text = "";
      descontroller.text = "";
      mydocid = "";
      category = "";
      fetchdata();
    });
  }

  @override
  void initState() {
    fetchdata();
    getcat();
    selectedValue = 'SoftDrink';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showalert();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        appBar: AppBar(
          title: Text(
            "Add Sub Categories",
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 248, 242, 241),
        ),
        body: Container(
          color: Color.fromARGB(255, 248, 242, 241),
          child: ListView.builder(
            itemCount: al.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.all(10),
                child: ListTile(
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                    "Category: ${al[index].Mycategory}",
                    style: TextStyle(
                        fontFamily: 'Metropolis', fontWeight: FontWeight.bold),
                  ),
                    Text(
                   "Subcategory Name: ${al[index].name}",
                    style: TextStyle(
                        fontFamily: 'Metropolis', fontWeight: FontWeight.w600),
                  ),Text(
                    "Description: ${al[index].desc}",
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                    ),
                  ),]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            isedit = true;
                            namecontroller.text = al[index].name;
                            descontroller.text = al[index].desc;
                            mydocid = al[index].id;
                            selectedValue = al[index].Mycategory;
                            showalert();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            mydocid = al[index].id;
                            confirmation();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        drawer: AppDrawer(sharedPref: widget.sharedPref),
      ),
    );
  }
}
