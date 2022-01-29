import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:your_project_name/src/card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:your_project_name/src/data_model.dart';

// Search Page
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Simple Inventory Management',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.grey,

          // The search area here
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      // controller: _searchController,
                      decoration: InputDecoration(
                          label: Text('search'), hintText: 'name'),
                      onChanged: (value) {
                        // if (value.length < 1) {
                        //   setState(() {
                        //     canSearch = false;
                        //     debugPrint(canSearch.toString());
                        //   });
                        // } else {
                        //   setState(() {
                        //     canSearch = true;
                        //     debugPrint(canSearch.toString());
                        //   });
                        // }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    // onPressed: canSearch == true
                    //     ? whatShouldIDO
                    //     : null, //if cansearch true return something, else return null
                    icon: Icon(Icons.search),
                  )
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('product')
                    .snapshots(),
                builder: (context, snapshot) {
                  try {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('error');
                    }
                  } on FirebaseAuthException catch (e) {
                    print(e);
                  }
                  List<DocumentSnapshot> _docs = snapshot.data!.docs;

                  List<Product> productList = _docs
                      .map((e) =>
                          Product.fromMap(e.data() as Map<String, dynamic>))
                      .toList();

                  return ListView.builder(
                    itemCount: productList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Container(
                          height: 80,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(50),
                                  child: Expanded(
                                    child: Image.asset("assets/1.png"),
                                    flex: 1,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white,
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: ListTile(
                                          title: Text(productList[index]
                                              .name
                                              .toString()),
                                          subtitle: Text(productList[index]
                                              .category
                                              .toString()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                flex: 3,
                              ),
                              Expanded(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.grey,
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          productList[index].quantity ?? '',
                                          textAlign: TextAlign.center,
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        elevation: 8,
                        margin: EdgeInsets.all(10),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
        //bottom Navigation Bar
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.list,
                    size: 30,
                  )),
              Container(
                child: SizedBox(
                    child: FloatingActionButton(
                  backgroundColor: Colors.red[900],
                  child: null,
                  shape: CircleBorder(
                      side: BorderSide(color: Colors.grey.shade800, width: 5)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/add');
                  },
                )),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.import_export,
                    size: 30,
                  ))
            ],
          ),
        ));
  }
}
