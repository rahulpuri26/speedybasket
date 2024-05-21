// app_drawer.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/addadmincategories.dart';
import 'package:speedy_basket/adminpanel.dart';
import 'package:speedy_basket/approveshop.dart';
import 'package:speedy_basket/subcat.dart';
import 'fetchusers.dart';

class AppDrawer extends StatelessWidget {
  final SharedPreferences sharedPref;

  AppDrawer({required this.sharedPref});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 248, 242, 241),
            ),
            child: Column(children: [
              Text(
              'Admin Menu',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Metropolis',
              ),
            ),
            CircleAvatar(radius: 50 ,backgroundImage: AssetImage("assets/logo.jpeg"),
            )
            ],)
          ),
          ListTile(
            leading: Icon(Icons.person_3),
            title: Text(
              'Main Panel',
              style: TextStyle(
                fontFamily: 'Metropolis',
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminPanel(sharedPref: sharedPref),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'View App Users',
              style: TextStyle(
                fontFamily: 'Metropolis',
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => fetchusers(sharedPref: sharedPref),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text(
              'Add Categories',
              style: TextStyle(
                fontFamily: 'Metropolis',
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => addcatg(sharedPref: sharedPref),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text(
              'Add Subcategories',
              style: TextStyle(
                fontFamily: 'Metropolis',
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => subcat(sharedPref: sharedPref),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text(
              'Approve ShopKeeper',
              style: TextStyle(
                fontFamily: 'Metropolis',
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => appshop(sharedPref: sharedPref),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'Metropolis',
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
