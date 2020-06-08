import 'package:ecommerce/ui/login.dart';
import 'package:ecommerce/utils/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/pages/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecommerce/db/product.dart';
import 'package:ecommerce/pages/updatedcart.dart';
import 'package:ecommerce/pages/favourites.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProductDetails extends StatefulWidget {
  final product_detail_name;
  final product_detail_picture;
  final product_detail_quantity;
  final product_detail_new_price;
  final product_detail_brand;
  final product_detail_category;
  final product_detail_id;

  ProductDetails(
      {this.product_detail_name,
      this.product_detail_picture,
      this.product_detail_quantity,
      this.product_detail_new_price,
      this.product_detail_brand,
      this.product_detail_category,
      this.product_detail_id});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ProductService _productService = ProductService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Colors.red,
        title: InkWell(
          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> new HomePage()));},
          child: Text('Fashapp')),
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> new FavouriteList()));
            },
          ),

          new IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              AuthProvider().logOut();
              // Navigator.push(context, MaterialPageRoute(builder: (context)=> new LoginPage()));
              
            },
          ),

//    Incase you want to keep the shopping cart icon on product details page as well
          // new IconButton(
          //   icon: Icon(
          //     Icons.shopping_cart,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {},  /* inside curly braces ===> Navigator.push(context, MaterialPageRoute(builder: (context) => new Cart())); */
          // )
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.network(widget.product_detail_picture),
              ),
              footer: new Container(
                color: Colors.white70,
                child: ListTile(
                  leading: new Text(
                    widget.product_detail_name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  title: new Row(
                    children: <Widget>[
                      Expanded(
                          child: new Text(
                        "Qty: ${widget.product_detail_quantity}",
                        style: TextStyle(
                            color: Colors.grey,
                            ),
                      )),
                      Expanded(
                          child: new Text(
                        "\$${widget.product_detail_new_price}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),

//            ================== the first buttons =====================

          Row(
            children: <Widget>[
//            ================== the size button ====================
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(context: context,
                    builder: (context){
                      return new AlertDialog(
                        title: new Text("Category"),
                        content: new Text("Category: ${widget.product_detail_category}"),
                        actions: <Widget>[
                          new MaterialButton(onPressed: (){
                            Navigator.of(context).pop(context);
                          },
                          child: new Text("close",style: TextStyle(color: Colors.red),),)
                        ],
                      );
                    });
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: new Text("Category"),),
                      // Expanded(child: new Icon(Icons.arrow_drop_down),),
                    ],
                  ),
                ),
              ),

              //            ================== the colour button ====================
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(context: context,
                    builder: (context){
                      return new AlertDialog(
                        title: new Text("Brands"),
                        content: new Text("Brand: ${widget.product_detail_brand}"),
                        actions: <Widget>[
                          new MaterialButton(onPressed: (){
                            Navigator.of(context).pop(context);
                          },
                          child: new Text("close",style: TextStyle(color: Colors.red),),)
                        ],
                      );
                    },
                    );
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: new Text("Brand"),),
                      // Expanded(child: new Icon(Icons.arrow_drop_down),),
                    ],
                  ),
                ),
              ),

              //            ================== the quantity button ====================
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(context: context,
                    builder: (context){
                      return new AlertDialog(
                        title: new Text("Quantity"),
                        content: new Text("Max quantity: ${widget.product_detail_quantity}"),
                        actions: <Widget>[
                          new MaterialButton(onPressed: (){
                            Navigator.of(context).pop(context);
                          },
                          child: new Text("close",style: TextStyle(color: Colors.red),),)
                        ],
                      );
                    });
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: new Text("Quantity"),),
                      // Expanded(child: new Icon(Icons.arrow_drop_down),),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          //            ================== the second buttons =====================

          Row(
            children: <Widget>[
//            ================== the size button ====================
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                      _productService.uploadToCart(
                      productName: widget.product_detail_name,
                      price: widget.product_detail_new_price,
                      images: widget.product_detail_picture,
                      quantity: int.parse('1'),
                      category: widget.product_detail_category.toString(),
                      brand: widget.product_detail_brand.toString());
                      Fluttertoast.showToast(
                      msg: "Product added to cart",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 19.0);
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  elevation: 0.2,
                  child: new Text("Add to Cart"),
                ),
              ),


              new IconButton(icon: Icon(Icons.add_shopping_cart, color: Colors.red,), onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => new UpdatedCart()));
              }),

              new IconButton(icon: Icon(Icons.favorite_border), color: Colors.red, onPressed: (){
                      _productService.addToFavourites(
                        productName: widget.product_detail_name,
                        price: widget.product_detail_new_price,
                        images: widget.product_detail_picture,
                        quantity: int.parse('1'),
                        category: widget.product_detail_category.toString(),
                        brand: widget.product_detail_brand.toString());
                      Fluttertoast.showToast(
                        msg: "Product added to Favourites",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                        fontSize: 19.0);
              }),
              
            
            ],
          ),
          Divider(),
          new ListTile(
            title: new Text("Product details"),
            subtitle: new Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
          ),
          Divider(),
      new Row(
        children: <Widget>[
          Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
          child: new Text("Product name", style: TextStyle(color: Colors.grey),),),
          Padding(padding: EdgeInsets.all(5.0),
          child: new Text(widget.product_detail_name),),
        ],
      ),

      new Row(
        children: <Widget>[
          Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
          child: new Text("Product brand", style: TextStyle(color: Colors.grey),),),

//       REMEMBER TO CREATE THE PRODUCT BRAND
          Padding(padding: EdgeInsets.all(5.0),
          child: new Text(widget.product_detail_brand),),
        ],
      ),

//    ADD THE PRODUCT  CONDITION
      new Row(
        children: <Widget>[
          Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
          child: new Text("Product condition", style: TextStyle(color: Colors.grey),),),
          Padding(padding: EdgeInsets.all(5.0),
          child: new Text("New"),),
        ],
      ),

      Divider(),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Similar products"),
      ),


//          SIMILAR PRODUCTS SECTION
        Container(
          height: 300.0,
          child: SimilarProducts(),
        )
        ],
      ),
    );
  }
}

class SimilarProducts extends StatefulWidget {
  @override
  _SimilarProductsState createState() => _SimilarProductsState();
}

class _SimilarProductsState extends State<SimilarProducts> {
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
                return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),));
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