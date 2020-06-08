import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: Text(
          "Products",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('newproducts').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot products = snapshot.data.documents[index];
              return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black)),
                    ),
                    child: Card(
                                          child: ListTile(
                        leading: Container(
                          child: Image.network(
                            products['images'],
                            height: 80,
                            width: 70,
                            fit: BoxFit.fill,
                          ),
                        ),
                        title: Text(products['name']),
                        subtitle: Text("\$${products['price'].toString()}"),
                      ),
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}
