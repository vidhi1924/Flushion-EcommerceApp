import 'package:flutter/material.dart';

class CartProducts extends StatefulWidget {
  @override
  _CartProductsState createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  var products_on_the_cart = [
    {
      "name": "Blazer for men",
      "picture": "images/products/blazer1.jpeg",
      // "old_price": 120,
      "price": 85,
      "size": "L",
      "colour": "Grey Black",
      "quantity": 1,
    },
    {
      "name": "Red dress",
      "picture": "images/products/dress1.jpeg",
      // "old_price": 100,
      "price": 50,
      "size": "M",
      "colour": "Red",
      "quantity": 1,
    },
    {
      "name": "Red heels",
      "picture": "images/products/hills2.jpeg",
      // "old_price": 50,
      "price": 30,
      "size": "7",
      "colour": "Red",
      "quantity": 1,
    },
    {
      "name": "Pants",
      "picture": "images/products/pants1.jpg",
      // "old_price": 60,
      "price": 20,
      "size": "M",
      "colour": "Black",
      "quantity": 1,
    },
    {
      "name": "Shoes",
      "picture": "images/products/shoe1.jpg",
      "old_price": 90,
      "price": 85,
      "size": "10",
      "colour": "Grey",
      "quantity": 1,
    },
    {
      "name": "Floral skirt",
      "picture": "images/products/skt1.jpeg",
      "old_price": 80,
      "price": 64,
      "size": "L",
      "colour": "Sea Green",
      "quantity": 1,
    },
    {
      "name": "Pink skirt",
      "picture": "images/products/skt2.jpeg",
      "old_price": 60,
      "price": 45,
      "size": "S",
      "colour": "Pink",
      "quantity": 1,
    },
    {
      "name": "Joggers",
      "picture": "images/products/pants2.jpeg",
      "old_price": 90,
      "price": 50,
      "size": "L",
      "colour": "Grey",
      "quantity": 1,
    },
    {
      "name": "Burgandy Heels",
      "picture": "images/products/hills1.jpeg",
      "old_price": 99,
      "price": 75,
      "size": "9",
      "colour": "Burgandy",
      "quantity": 1,
    },
    {
      "name": "Black dress",
      "picture": "images/products/dress2.jpeg",
      "old_price": 100,
      "price": 30,
      "size": "M",
      "colour": "Black",
      "quantity": 1,
    },
    {
      "name": "Blazer for women",
      "picture": "images/products/blazer2.jpeg",
      "old_price": 89,
      "price": 85,
      "size": "M",
      "colour": "Black",
      "quantity": 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: products_on_the_cart.length,
        itemBuilder: (context, index) {
          return SingleCartProduct(
            cart_prod_name: products_on_the_cart[index]["name"],
            cart_prod_picture: products_on_the_cart[index]["picture"],
            cart_prod_price: products_on_the_cart[index]["price"],
            cart_prod_size: products_on_the_cart[index]["size"],
            cart_prod_colour: products_on_the_cart[index]["colour"],
            cart_prod_qty: products_on_the_cart[index]["quantity"],
          );
        });
  }
}

class SingleCartProduct extends StatelessWidget {
  final cart_prod_name;
  final cart_prod_picture;
  final cart_prod_price;
  final cart_prod_size;
  final cart_prod_colour;
  final cart_prod_qty;

  SingleCartProduct(
      {this.cart_prod_name,
      this.cart_prod_picture,
      this.cart_prod_price,
      this.cart_prod_size,
      this.cart_prod_colour,
      this.cart_prod_qty});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
//  ================== LEADING SECTION =======================
        leading: Image.asset(cart_prod_picture),

// ===================== TITLE SECTION =====================
        title: Text(cart_prod_name),

// ====================== SUBTITLE SECTION =================
        subtitle: Column(
          children: <Widget>[
//  ==================== ROW INSIDE THE COLUMN ====================
            Row(
              children: <Widget>[
//        this section is for the size of the product
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text("Size:"),
                ),

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    cart_prod_size,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

//        this section is for the colour of the product
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
                  child: Text("Colour:"),
                ),

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    cart_prod_colour,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),

// =========================== THIS SECTION IS FOR THE PRODUCT PRICE ===============================
            new Container(
              alignment: Alignment.topLeft,
              child: Text(
                "\$${cart_prod_price}",
                style: TextStyle(fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.red),
              ),
            ),
          ],
        ),
        trailing: FittedBox(
          fit: BoxFit.fill,
                  child: Column(
            children: <Widget>[
              IconButton(icon: Icon(Icons.arrow_drop_up), iconSize: 1000, onPressed: (){}),
              Text('$cart_prod_qty',style: TextStyle(fontSize: 500,fontWeight: FontWeight.bold),),
              IconButton(icon: Icon(Icons.arrow_drop_down),iconSize: 1000, onPressed: (){}),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              //   child: IconButton(icon: Icon(Icons.arrow_drop_down), onPressed: (){}),
              // ),
            ],
          ),
        ),
      ),
    );
  }
  
}
