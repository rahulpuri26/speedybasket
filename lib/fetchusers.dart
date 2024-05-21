import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/appdrawer.dart';
import 'package:speedy_basket/usersmapping.dart';

class fetchusers extends StatefulWidget {
  final SharedPreferences sharedPref;
  fetchusers({super.key, required this.sharedPref});

  @override
  State<fetchusers> createState() => _fetchusersState();
}

class _fetchusersState extends State<fetchusers> {
  List<users> al3 = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    al3.clear();
    final response = await FirebaseFirestore.instance.collection("users").get();
    setState(() {
      if (response.docs.isNotEmpty) {
        for (var data in response.docs) {
          String name = data["name"];
          String status = data["status"];
          String role = data["role"];
          String userid = data.id;
          al3.add(users(name, status, role, userid));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "App Users",
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
            itemCount: al3.length,
            itemBuilder: (context, index) {
              final user = al3[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text("Name : ${user.name}",style: TextStyle(
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
            ),),
                  subtitle:
                      Text("Status: ${user.status}\nRole: ${user.role}",style: TextStyle(
              fontFamily: 'Metropolis',
            ),),
                  trailing: Text(user.userid,style: TextStyle(
              fontFamily: 'Metropolis',
            ),),
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
