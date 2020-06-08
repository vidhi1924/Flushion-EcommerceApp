import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecommerce/pages/finalpage.dart';
// import 'finalpage.dart';

class UpdatedCart extends StatefulWidget {
  @override
  _UpdatedCartState createState() => _UpdatedCartState();
}

class _UpdatedCartState extends State<UpdatedCart> {
  int total = 0;
  int cartcount = 0;

  void getinfo()async{
                      var cartinfo = await Firestore.instance.collection('cart').getDocuments();
                      setState(() {
                        print(cartinfo.documents.length);
                        cartcount = cartinfo.documents.length;
                      });}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getinfo();
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
        body: StreamBuilder(
          stream: Firestore.instance.collection('cart').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: Center(
                    child: Text(
                  'No items in the cart',
                  style: TextStyle(color: Colors.grey),
                )),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot products = snapshot.data.documents[index];
                  String prodid = products['id'];
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
                      Firestore.instance
                          .collection('cart')
                          .document(prodid)
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
                          subtitle: Text(
                            products['price'].toString(),
                            style: TextStyle(color: Colors.red),
                            
                          ),
                        ),
                      ));
                },
              );
            }
          },
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,5,0),
                child: Container(
                  width: 200,
                  height: 36,
                  child: Expanded(
                    child: MaterialButton(
                    onPressed: () {
                      
                      
                      if(cartcount != 0){
                        Fluttertoast.showToast(
                          msg: "Order Placed Succesfully",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 18.0);
                      }
                      else{
                        Fluttertoast.showToast(
                          msg: "Cart is empty",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 18.0);
                      }
                    },
                    color: Colors.red,
                    child: Text("Buy Now"),
                    textColor: Colors.white,
                  ),
                  ),
                ),
              ),
              Expanded(
                  child: MaterialButton(
                onPressed: () {
                  Firestore.instance
                      .collection('cart')
                      .getDocuments()
                      .then((snapshot) {
                    for (DocumentSnapshot ds in snapshot.documents) {
                      ds.reference.delete();
                    }
                  });
                  if(cartcount != 0){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FinalPage()));
                  }
                  else{
                    Fluttertoast.showToast(
                          msg: "Cart is empty",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 18.0);
                  } 
                },
                color: Colors.red,
                child: Text("Checkout"),
                textColor: Colors.white,
              ),
              )
            ],
          ),
        ));
  }
}
