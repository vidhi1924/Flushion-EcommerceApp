import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/pages/product_details.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: Firestore.instance.collection('newproducts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
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
                        // product_list[index]['quantity'].toString(),
                        prod_price: products['price'],
                        prod_quantity: products['quantity'],
                        // prod_brand: products['brand'],
                        // prod_category: products['category'],
                        // prod_size: products['price'],
                        prod_brand: products['brand'],
                        prod_category: products['category'],
                        prod_id: products['id']
                      );
                      // product_list[index]['price'].toString());
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                );
              }
            }));
    // return Scaffold(
    //       body: StreamBuilder(
    //         stream: Firestore.instance.collection('newproducts').snapshots(),
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData) {),
    //       child: GridView.builder(
    //       itemCount: product_list.length,
    //       gridDelegate:
    //           new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    //       itemBuilder: (BuildContext context, int index) {
    //         return Single_prod(
    //           prod_name: product_list[index]['name'],
    //           prod_picture: product_list[index]['picture'],
    //           prod_old_price: product_list[index]['old_price'],
    //           prod_price: product_list[index]['price'],
    //         );
    //       }),
    // );
  }
}

class Single_prod extends StatelessWidget {

  final prod_name;
  final prod_picture;
  final prod_price;
  final prod_quantity;
  final prod_brand;
  final prod_category;
  final prod_id;

  Single_prod({
    this.prod_name,
    this.prod_picture,
    this.prod_price,
    this.prod_quantity,
    this.prod_brand,
    this.prod_category,
    this.prod_id
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
          tag: prod_name,
          child: Material(
            child: InkWell(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                // here we are passing the values of the product to product details page
                  builder: (context) => new ProductDetails(
                    product_detail_name: prod_name,
                    product_detail_picture: prod_picture,
                    product_detail_quantity: prod_quantity,
                    product_detail_new_price: prod_price,
                    product_detail_brand: prod_brand,
                    product_detail_category: prod_category,
                    product_detail_id: prod_id
                  ))),
              child: GridTile(
                  footer: Container(
                    color: Colors.white70,
                    child: new Row(children: <Widget>[
                      Expanded(
                        child: Text(prod_name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                        ),
                        Text("\$${prod_price}", style: TextStyle(color: Colors.red),), 
                    ],),
                  ),
                  child: Image.network(
                    prod_picture,
                    fit: BoxFit.cover,
                  )),
            ),
          )),
    );
  }
}


