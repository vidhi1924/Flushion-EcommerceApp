import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecommerce/db/product.dart';
import 'package:ecommerce/pages/finalpage.dart';

class UpdatedCart extends StatefulWidget {
  @override
  _UpdatedCartState createState() => _UpdatedCartState();
}

class _UpdatedCartState extends State<UpdatedCart> {
  final ProductService _productService = ProductService();
  int cartcount = 0;
  bool _checkingOut = false;
  late final StreamSubscription<QuerySnapshot> _cartSub;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Query<Map<String, dynamic>> get _cartQuery => FirebaseFirestore.instance
      .collection('cart')
      .where('userId', isEqualTo: _uid);

  @override
  void initState() {
    super.initState();
    // Keeps cartcount accurate in real time so the checkout buttons below
    // always reflect the true cart state, even after items are deleted.
    _cartSub = _cartQuery.snapshots().listen((snapshot) {
      if (mounted) setState(() => cartcount = snapshot.docs.length);
    });
  }

  @override
  void dispose() {
    _cartSub.cancel();
    super.dispose();
  }

  Future<void> _checkout() async {
    if (_checkingOut) return;
    setState(() => _checkingOut = true);
    try {
      final cartSnapshot = await _cartQuery.get();
      if (cartSnapshot.docs.isEmpty) {
        Fluttertoast.showToast(
            msg: "Cart is empty",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 18.0);
        return;
      }

      double total = 0;
      final items = cartSnapshot.docs.map((doc) {
        final data = doc.data();
        final price = (data['price'] as num?)?.toDouble() ?? 0;
        final quantity = (data['quantity'] as num?)?.toInt() ?? 1;
        total += price * quantity;
        return {
          'name': data['name'],
          'images': data['images'],
          'price': price,
          'quantity': quantity,
          'brand': data['brand'],
          'category': data['category'],
        };
      }).toList();

      await FirebaseFirestore.instance.collection('orders').add({
        'userId': _uid,
        'items': items,
        'total': total,
        'status': 'Placed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      for (final doc in cartSnapshot.docs) {
        await doc.reference.delete();
      }

      Fluttertoast.showToast(
          msg: "Order Placed Succesfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 18.0);

      if (mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FinalPage()));
      }
    } finally {
      if (mounted) setState(() => _checkingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            "Shopping Cart",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _cartQuery.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No items in the cart',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot products = snapshot.data!.docs[index];
                String prodid = products['id'];
                int quantity = (products['quantity'] as num?)?.toInt() ?? 1;
                return Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 6, 0, 6),
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black)),
                      ),
                      child: ListTile(
                        leading: Container(
                          height: 150,
                          child: Image.network(
                            products['images'],
                            height: 150,
                            width: 70,
                          ),
                        ),
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(products['name']),
                            ),
                            Expanded(
                                child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                FirebaseFirestore.instance
                                    .collection('cart')
                                    .doc(prodid)
                                    .delete();
                                Fluttertoast.showToast(
                                    msg: "Product Removed",
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    gravity: ToastGravity.CENTER);
                              },
                            ))
                          ],
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            Text(
                              products['price'].toString(),
                              style: TextStyle(color: Colors.red),
                            ),
                            const SizedBox(width: 16.0),
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline,
                                  size: 20.0),
                              onPressed: () => _productService
                                  .updateCartQuantity(prodid, quantity - 1),
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon:
                                  Icon(Icons.add_circle_outline, size: 20.0),
                              onPressed: () => _productService
                                  .updateCartQuantity(prodid, quantity + 1),
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            );
          },
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Container(
                  width: 200,
                  height: 36,
                  child: MaterialButton(
                    onPressed: _checkingOut ? null : _checkout,
                    color: Colors.red,
                    child: Text("Buy Now"),
                    textColor: Colors.white,
                  ),
                ),
              ),
              Expanded(
                  child: MaterialButton(
                onPressed: _checkingOut ? null : _checkout,
                color: Colors.red,
                child: Text("Checkout"),
                textColor: Colors.white,
              ))
            ],
          ),
        ));
  }
}
