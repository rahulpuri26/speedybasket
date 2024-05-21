import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/addpro.dart';
import 'package:speedy_basket/mycategory.dart';
import 'package:speedy_basket/subcat.dart';
import 'package:speedy_basket/subcategory.dart';

class shopkdash extends StatefulWidget {
  final SharedPreferences sharedPref;
  shopkdash({super.key, required this.sharedPref});

  @override
  State<shopkdash> createState() => _shopkdashState();
}

class _shopkdashState extends State<shopkdash> {
  final catgformkey = GlobalKey<FormState>();
  List<MyCategory> al = [];
  List<subCategory> al2 = [];

  @override
  void initState() {
    fetchdata();
    getcat();
    super.initState();
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
        }
      }
    });
  }

  void getcat() async {
    final Response =
        await FirebaseFirestore.instance.collection("subcategories").get();
    setState(() {
      if (Response.docs.isNotEmpty) {
        for (var data in Response.docs) {
          String name = data["subcatgname"];
          String desc = data["subcatgdes"];
          String id = data.id;
          String Mycategory = data["category"];
          String pic = data["subcpic"];
          al2.add(subCategory(name, desc, pic, id, Mycategory));
        }
      }
    });
  }

  void showalert(MyCategory category) async {
    List<subCategory> filteredSubcategories =
        al2.where((subCat) => subCat.Mycategory == category.name).toList();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "${category.name}",
                style: TextStyle(
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Container(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < filteredSubcategories.length; i++)
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => addproduct(
                                  sharedPref: widget.sharedPref,
                                  subcategoryName:
                                      filteredSubcategories[i].name,
                                ),
                              ),
                            );
                          },
                         title: Text(
                          filteredSubcategories[i].name,
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                          ),
                        ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Sub Categories",
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 248, 242, 241),
        ),
        body: Container(
            color: Color.fromARGB(255, 248, 242, 241),
            child: GridView.extent(
              maxCrossAxisExtent: 210,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              padding: const EdgeInsets.all(8.0),
              children: List.generate(al.length, (index) {
                return InkWell(
                  onTap: () {
                    showalert(al[index]);
                    print('Tapped on ${al[index].name}');
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: GridTile(
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                al[index].pic,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text(
                              al[index].name,
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              al[index].des,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            )),
      ),
    );
  }
}
