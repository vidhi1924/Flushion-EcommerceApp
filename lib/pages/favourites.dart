import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'product_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/pages/home.dart';

class FavouriteList extends StatefulWidget {
  @override
  _FavouriteListState createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: Text("Your Favourites"),
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection('favourites').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                ));
              } else {
                return GridView.builder(
                    itemCount: snapshot.data.documents.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot products =
                          snapshot.data.documents[index];
                      return Single_prod(
                          prod_name: products['name'],
                          prod_picture: products['images'],
                          prod_quantity: products['quantity'],
                          // product_list[index]['quantity'].toString(),
                          prod_price: products['price'],
                          prod_id: products['id'],
                          prod_brand: products['brand'],
                          prod_category: products['category'],);
                      // product_list[index]['price'].toString());
                    });
              }
            },
            ),
            bottomNavigationBar: Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: MaterialButton(
                height: 50,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                color: Colors.red,
                child: Text(
                  "Shop More ?",
                  style: TextStyle(fontSize: 21),
                ),
                textColor: Colors.white,
              ))
            ],
          ),
        )
          );
  }
}

class Single_prod extends StatelessWidget {
  final prod_name;
  final prod_picture;
  final prod_quantity;
  final prod_price;
  final prod_id;
  final prod_brand;
  final prod_category;

  Single_prod(
      {this.prod_name,
      this.prod_picture,
      this.prod_quantity,
      this.prod_price,
      this.prod_id,
      this.prod_brand,
      this.prod_category});
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Hero(
      tag: new Text("hero 1"),
      child: Material(
        child: InkWell(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => ProductDetails(
                      product_detail_name: prod_name,
                      product_detail_new_price: prod_price,
                      product_detail_quantity: prod_quantity,
                      product_detail_picture: prod_picture,
                      product_detail_brand: prod_brand,
                      product_detail_category: prod_category,
                    ))),
            // Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new ProductDetails())),
            child: GridTile(
              header: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      Firestore.instance
                          .collection('favourites')
                          .document(prod_id)
                          .delete();
                      Fluttertoast.showToast(
                        gravity: ToastGravity.CENTER,
                          msg: "Product Removed",
                          backgroundColor: Colors.black54,
                          textColor: Colors.white);
                    }
                    ),
              ),
              footer: Container(
                  color: Colors.white70,
                  child: ListTile(
                      leading: Text(
                        prod_name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: Text(
                        "Rs $prod_price",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      subtitle: Text(
                        "$prod_quantity",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.black54,
                            decoration: TextDecoration.lineThrough),
                      ))),
              child: Image.network(prod_picture),
            ),
          ),
      ),
    ),
    );
  }
}
