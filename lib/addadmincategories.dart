import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/appdrawer.dart';
import 'package:speedy_basket/mycategory.dart';

class addcatg extends StatefulWidget {
   final SharedPreferences sharedPref;
addcatg({required this.sharedPref});
  @override
  State<addcatg> createState() => _addcatgState();
}

class _addcatgState extends State<addcatg> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController descontroller = TextEditingController();
  bool isedit = false;
  String mydocid = "";
  final catgformkey = GlobalKey<FormState>();
  String Category = "Add Category";
  List<MyCategory> al = [];

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
        // barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(Category,style: TextStyle(
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
            ),),
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
                  label: Text("Save",style: TextStyle(
              fontFamily: 'Metropolis',
            ),)),
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel),
                  label: Text("Close",
                  style: TextStyle(
              fontFamily: 'Metropolis',
            ),)),
            ],
          );
        });
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
            )),
            content: Text("Do You Want To Delete ?",style: TextStyle(
              fontFamily: 'Metropolis',
            )),
            actions: [
              ElevatedButton.icon(
                  onPressed: () {
                    delete();
                  },
                  icon: Icon(Icons.check_circle),
                  label: Text("Yes",style: TextStyle(
              fontFamily: 'Metropolis',
            ))),
              ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel),
                  label: Text("No",style: TextStyle(
              fontFamily: 'Metropolis',
            ))),
            ],
          );
        });
  }
  void update() async {
    String catgname = namecontroller.text;
    String catgdes = descontroller.text;

    await FirebaseFirestore.instance
        .collection("categories")
        .doc(mydocid)
        .update({"catgname": catgname, "catgdes": catgdes});

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
  void initState() {
    super.initState();
    fetchdata();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isedit = false;
              namecontroller.text = "";
              descontroller.text = "";
              showalert();
            });
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(
            "Add Categories",
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
                  leading:  Image.network(al[index].pic, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(al[index].name,style: TextStyle(
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
            ),),
                  subtitle: Text(al[index].des,style: TextStyle(
              fontFamily: 'Metropolis',
            ),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            isedit = true;
                            namecontroller.text = al[index].name;
                            descontroller.text = al[index].des;
                            mydocid = al[index].docid;
                            showalert();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            mydocid = al[index].docid;
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