import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/mycategory.dart';
import 'package:speedy_basket/shopdata.dart';
import 'package:speedy_basket/subcat.dart';

class CatgMst extends StatefulWidget {
  final SharedPreferences sharedPref;
  CatgMst({super.key, required this.sharedPref});

  @override
  State<CatgMst> createState() => _CatgMstState();
}

class _CatgMstState extends State<CatgMst> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController descontroller = TextEditingController();
  bool isedit = false;
  String mydocid = "";
  String shopid = "";
  List<MyCategory> al = [];
  final catgformkey = GlobalKey<FormState>();
  String status = "";

  String Category = "Add Category";

  void showalert() {
    if (isedit) {
      setState(() {
        Category = "Modify Category";
      });
    } else {
      setState(() {
        Category = "Add Category";
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
    await FirebaseFirestore.instance.collection("categories").add({
      "catgname": namecontroller.text.trim(),
      "catgdes": descontroller.text.trim(),
      "pic": "",
    });

    namecontroller.text = "";
    descontroller.text = "";
    fetchdata();
  }

  void fetchdata() async {
    al.clear();
    final Response =
        await FirebaseFirestore.instance.collection("categories").get();
    setState(() {
      if (Response.docs.isNotEmpty) {
        for (var data in Response.docs) {
          String name = data["catgname"];
          String des = data["catgdes"];
          String pic = data["pic"];
          String mydocid = data.id;

          al.add(MyCategory(name, des, pic, mydocid));
          ;
        }
      }
    });
  }

  List<shopdata> al2 = [];
  void fetchshopkeeper() async {
    al2.clear();
    final Response = await FirebaseFirestore.instance.collection("users").get();
    setState(() {
      if (Response.docs.isNotEmpty) {
        for (var data in Response.docs) {
          String shopname = data["shopname"];
          String status = data["status"];
          String role = data["role"];
          String shopid = data.id;
          al2.add(shopdata(shopname, status, shopid, role));
          print(shopid);
        }
      }
    });
  }

  List<dynamic> al3 = [];
  void fetchusers() async {
    al3.clear();
    final Response = await FirebaseFirestore.instance.collection("users").get();
    setState(() {
      if (Response.docs.isNotEmpty) {
        for (var data in Response.docs) {
          String name = data["name"];
          String status = data["status"];
          String role = data["role"];
          String userid = data.id;
          al3.add(name);
          al3.add(status);
          al3.add(role);
          al3.add(userid);
        }
      }
    });
  }

  void update() async {
    String catgname = namecontroller.text;
    String catgdes = descontroller.text;
    String pic = " ";

    await FirebaseFirestore.instance
        .collection("categories")
        .doc(mydocid)
        .update({"catgname": catgname, "catgdes": catgdes, "pic": pic});

    setState(() {
      isedit = false;
      namecontroller.text = "";
      descontroller.text = "";
      mydocid = "";
      fetchdata();
    });
  }

  void delete() async {
    await FirebaseFirestore.instance
        .collection("categories")
        .doc(mydocid)
        .delete();
    fetchdata();
  }

  void updateshopkeeper(String shopid, String currentStatus) async {
    String newStatus = currentStatus == "pending" ? "approved" : "pending";

    await FirebaseFirestore.instance
        .collection("users")
        .doc(shopid)
        .update({"status": newStatus});

    setState(() {
      fetchshopkeeper();
    });
  }

  @override
  void initState() {
    fetchdata();
    fetchshopkeeper();
    super.initState();
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
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => subcat(sharedPref: widget.sharedPref)),
              );
            },
            child: Icon(Icons.abc),
            backgroundColor: Colors.red,
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
            Expanded(
                child: ListView(children: [
              for (int i = 0; i < al2.length; i++)
                ListTile(
                  title: Text(al2[i].shopname),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    TextButton(
                        onPressed: () {
                          updateshopkeeper(al2[i].shopid, al2[i].status);
                          print(al2[i].shopid);
                        },
                        child: Text(al2[i].status))
                  ]),
                )
            ])),
          ],
        ),
      ),
    );
  }
}
