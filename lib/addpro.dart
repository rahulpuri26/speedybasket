import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedy_basket/prodclass.dart';

class addproduct extends StatefulWidget {
  final SharedPreferences sharedPref;
  final String subcategoryName;
  addproduct(
      {super.key, required this.sharedPref, required this.subcategoryName});

  @override
  State<addproduct> createState() => _addproductState();
}

class _addproductState extends State<addproduct> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController descontroller = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController specialprice = TextEditingController();
  TextEditingController productquantity = TextEditingController();
  TextEditingController itemunit = TextEditingController();
  PlatformFile? selectedfile;
  bool isselected = false;
  File? myImage;
  final prodformkey = GlobalKey<FormState>();

  List<products> al = [];

  void pickfilesforweb() async {
    FilePickerResult? pickedresult =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (pickedresult != null) {
      setState(() {
        selectedfile = pickedresult.files.first;
        isselected = true;
        print(isselected);
      });
    }
  }

  void pickFilesforOthers(ImageSource source) async {
    final pickedresult = await ImagePicker().pickImage(source: source);

    if (pickedresult != null) {
      setState(() {
        myImage = File(pickedresult.path);
        isselected = true;
      });
    }
  }

  void uploadtoStorage() async {
    try {
      final ref = await FirebaseStorage.instance
          .ref("students")
          .child(selectedfile!.name!);

       ref.putData(selectedfile!.bytes!);

      final token = await ref.getDownloadURL();
      print(token);
    } catch (e) {
      print(e);
    }
  }

  void adddata() async {
    await FirebaseFirestore.instance.collection("products").add({
      "productname": namecontroller.text.trim(),
      "productdes": descontroller.text.trim(),
      "prodpic": "",
      "productquan": productquantity.text,
      "price": price.text,
      "specialprice": specialprice.text,
      "subcategoryName": widget.subcategoryName,
      "itemunit": itemunit.text
    });

    setState(() {
      namecontroller.text = "";
      descontroller.text = "";
      productquantity.text = " ";
      price.text = " ";
      specialprice.text = " ";
      itemunit.text = " ";

      fetchdata();
    });
  }

  void fetchdata() async {
    al.clear();
    final Response = await FirebaseFirestore.instance
        .collection("products")
        .where("subcategoryName", isEqualTo: widget.subcategoryName)
        .get();
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

  void showalert() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Add Product in ${widget.subcategoryName}",
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(
                height: 400,
                child: SingleChildScrollView(
                  child: Form(
                      key: prodformkey,
                      child: Column(
                        children: [
                          TextFormField(
                              controller: namecontroller,
                              decoration: InputDecoration(
                                  labelText: "Product Name",
                                  hintText: "Product Name"),
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
                          TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: price,
                              decoration: InputDecoration(
                                  labelText: "Price", hintText: "Price"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field is Mandatory";
                                }
                              }),
                          TextFormField(
                              controller: itemunit,
                              decoration: InputDecoration(
                                  labelText: "Enter Item Unit",
                                  hintText: "Item Unit"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field is Mandatory";
                                }
                              }),
                          TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: specialprice,
                              decoration: InputDecoration(
                                  labelText: "Special Price",
                                  hintText: "Special Price after Discount"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field is Mandatory";
                                }
                              }),
                          TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: productquantity,
                              decoration: InputDecoration(
                                  labelText: "Item Quantity",
                                  hintText: "Item Quantity"),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Field is Mandatory";
                                }
                              }),
                              Center(
                child: Column(
                  children: [
                    Container(
                        child: (isselected)
                            ? CircleAvatar(radius: 60,
                                backgroundImage: MemoryImage(
                                    Uint8List.fromList(selectedfile!.bytes!)),
                              )
                            : Text(
                                "No Image Selected",
                                style: TextStyle(
                                  fontFamily: 'Metropolis',
                                ),
                              )),
                    ElevatedButton.icon(
                        onPressed: () {
                          pickfilesforweb();
                          isselected = false;
                        },
                        icon: Icon(Icons.upload),
                        label: Text(
                          "Choose Image",
                          style: TextStyle(
                            fontFamily: 'Metropolis',
                          ),
                        ))
                  ],
                ),
              )
                        ],
                      ),
                      ),
                      
                )),
                
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        adddata();
                      },
                      icon: Icon(Icons.check_circle),
                      label: Text(
                        "Save",
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                        ),
                      )),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.cancel),
                      label: Text(
                        "Close",
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                        ),
                      )),
                ],
              ),
    
            ],
          );
        });
  }

  void delete(String docid) async {
    try {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(docid)
          .delete();
      fetchdata();
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  IconButton deletebutton(String docid) {
    return IconButton(
      icon: Icon(Icons.delete),
      color: Colors.black,
      onPressed: () {
        delete(docid);
      },
    );
  }

  void initState() {
    fetchdata();
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
      appBar: AppBar(
        title: Text(
          "${widget.subcategoryName}",
          style:
              TextStyle(fontFamily: 'Metropolis', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 248, 242, 241),
      ),
      body: Container(
        color: Color.fromARGB(255, 248, 242, 241),
        child: ListView.builder(
          itemCount: al.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(al[index].pic),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              al[index].name,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Description: ${al[index].desc}',
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'Metropolis'),
                            ),
                            Text(
                              'Price: ${al[index].price}',
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'Metropolis'),
                            ),
                            Text(
                              'Special Price: ${al[index].sprice}',
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'Metropolis'),
                            ),
                            Text(
                              'Quantity: ${al[index].quantity}',
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'Metropolis'),
                            ),
                            Text(
                              'Item Unit: ${al[index].itemunit}',
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'Metropolis'),
                            ),
                          ],
                        ),
                      ),
                      deletebutton(al[index].docid),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ));
  }
}
