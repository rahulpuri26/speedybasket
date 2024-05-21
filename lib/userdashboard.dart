import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  List<String> imageUrls = [
    'assets/offers.jpeg',
    'assets/offers2.png',
    'assets/offers3.jpeg',
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
          String itemunit = data["itemunit"];

          al.add(products(name, desc, pic, docid, price, sprice, quantity,
              subcname, itemunit));
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
        body: SingleChildScrollView(
          child: Column(
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
                          width: 350,
                          height: 180,
                          child: Image.asset(
                            imageUrls[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Row(
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
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: 800,
                child: GridView.extent(maxCrossAxisExtent: 200,
                  children: [
                    for (int i = 0; i < al2.length; i++)
                      GridTile(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => dummy()),
                        );
                              },
                              child: Card(
                              child: Container(
                                color: Colors.white,
                                width: 85.0,
                                height: 90.0,
                                child: Image.network(
                                  al2[i].pic, // Use the image URL from al2
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            ),
                            SizedBox(height: 5),
            Text(
              al2[i].name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
