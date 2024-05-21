import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/appdrawer.dart';
import 'package:speedy_basket/shopdata.dart';

class appshop extends StatefulWidget {
  final SharedPreferences sharedPref;
  appshop({super.key, required this.sharedPref});

  @override
  State<appshop> createState() => _appshopState();
}

class _appshopState extends State<appshop> {
  String status = "";
  List<shopdata> al2 = [];
  void fetchshopkeeper() async {
    try {
      final Response =
          await FirebaseFirestore.instance.collection("users").get();
      setState(() {
        al2.clear();
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
              al2.add(shopdata(shopname, status, shopid, role));
              print(shopid);
            }
          }
        }
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
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

  void initState() {
    fetchshopkeeper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Validate Shopkeepers",
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 248, 242, 241),
        ),
        body: Container(
          color: Color.fromARGB(255, 248, 242, 241),
          child: ListView(children: [
            for (int i = 0; i < al2.length; i++)
              Card(
                elevation: 7,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  title: Text(
                    al2[i].shopname,
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Status: ${al2[i].status}',
                    style: TextStyle(
                      fontFamily: 'Metropolis',
                      fontSize: 14,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          updateshopkeeper(al2[i].shopid, al2[i].status);
                          print(al2[i].shopid);
                        },
                        child: Text(
                          al2[i].status,
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: al2[i].status == 'approved'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ]),
        ),
        drawer: AppDrawer(sharedPref: widget.sharedPref),
      ),
    );
  }
}
