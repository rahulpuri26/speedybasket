import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/appdrawer.dart';
import 'package:speedy_basket/mycategory.dart';
import 'package:speedy_basket/shopdata.dart';
import 'package:speedy_basket/subcategory.dart';
import 'package:speedy_basket/usersmapping.dart';
import 'fetchusers.dart';

class AdminPanel extends StatefulWidget {
  final SharedPreferences sharedPref;
  AdminPanel({super.key, required this.sharedPref});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  List<MyCategory> al = [];
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

  List<subCategory> al2 = [];
  void fetchsubcdata() async {
    al2.clear();
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
          al2.add(subCategory(name, desc, pic, mydocid, Mycategory));
          ;
        }
      }
    });
  }

  List<users> al3 = [];
  void fetchUsers() async {
    al3.clear();
    final response = await FirebaseFirestore.instance.collection("users").get();
    setState(() {
      if (response.docs.isNotEmpty) {
        for (var data in response.docs) {
          String name = data["name"];
          String role = data["role"];
          String status = data["status"];
          String userid = data.id;
          al3.add(users(name, role, status, userid));
        }
      }
    });
  }

  List<shopdata> al4 = [];
  void fetchshopkeeper() async {
    try {
      final Response =
          await FirebaseFirestore.instance.collection("users").get();
      setState(() {
        al4.clear();
        if (Response.docs.isNotEmpty) {
          for (var data in Response.docs) {
            var documentData = data.data();
            if (documentData.containsKey("shopname") &&
                documentData.containsKey("status") &&
                documentData.containsKey("role")) {
              String shopname = documentData["shopname"];
              String status = documentData["status"];
              String role = documentData["role"];
              String shopid = data.id;
              al4.add(shopdata(shopname, status, shopid, role));
              print(shopid);
            }
          }
        }
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void initState() {
    fetchUsers();
    fetchsubcdata();
    fetchdata();
    fetchshopkeeper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Panel",
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 248, 242, 241),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 248, 242, 241),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  'Users',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Metropolis',
                  ),
                ),
              ),
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: al3.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        width: 200,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              al3[index].name,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Metropolis',
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              "Role: ${al3[index].role}",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Metropolis',
                              ),
                            ),
                            Text(
                              "Status: ${al3[index].status}",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Metropolis',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Metropolis',
                  ),
                ),
              ),
              Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: al.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        width: 200,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              al[index].pic,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              al[index].name,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Metropolis',
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              al[index].des,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Metropolis',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text(
                  'Subcategories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Metropolis',
                  ),
                ),
              ),
              Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: al2.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        width: 170,
                        height: 70,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              al2[index].name,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Metropolis',
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              al2[index].desc,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Metropolis',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text(
                  'Summary Of Application',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Metropolis',
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                child: ListTile(
                  title: Text(
                    'Number of Users: ${al3.length}',
                    style: TextStyle(fontSize: 18, fontFamily: 'Metropolis'),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                child: ListTile(
                  title: Text(
                    'Number of Shopkeepers: ${al4.length}',
                    style: TextStyle(fontSize: 18, fontFamily: 'Metropolis'),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                child: ListTile(
                  title: Text(
                    'Number of Shopkeepers Pending Approval: ${al4.where((shopkeeper) => shopkeeper.status == "pending").length}',
                    style: TextStyle(fontSize: 18, fontFamily: 'Metropolis'),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                child: ListTile(
                  title: Text(
                    'Number of Categories: ${al.length}',
                    style: TextStyle(fontSize: 18, fontFamily: 'Metropolis'),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                child: ListTile(
                  title: Text(
                    'Number of Subcategories: ${al2.length}',
                    style: TextStyle(fontSize: 18, fontFamily: 'Metropolis'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(sharedPref: widget.sharedPref),
    );
  }
}
