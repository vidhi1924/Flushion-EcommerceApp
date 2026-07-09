import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';

// my own imports
import 'package:ecommerce/components/horizontal_listview.dart';
import 'package:ecommerce/components/products.dart';
import 'package:ecommerce/utils/firebase_auth.dart';
import 'package:ecommerce/admin/admin.dart';
import 'package:ecommerce/pages/about.dart';
import 'package:ecommerce/pages/my_account.dart';
import 'package:ecommerce/pages/my_orders.dart';
import 'package:ecommerce/pages/settings.dart';
import 'package:ecommerce/pages/updatedcart.dart';
import 'package:ecommerce/pages/favourites.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
  Widget image_carousel = new Container(
    height: 200.0,
    child: CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        viewportFraction: 1.0,
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlayAnimationDuration: Duration(milliseconds: 1000),
      ),
      items: [
        'images/c1.jpg',
        'images/m1.jpeg',
        'images/w3.jpeg',
        'images/w4.jpeg',
        'images/m2.jpg',
      ].map((path) {
        return Image.asset(path, fit: BoxFit.cover, width: double.infinity);
      }).toList(),
    ),
  );
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text('Fashapp'),
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: (
            ) {              Navigator.push(context, MaterialPageRoute(builder: (context)=> new FavouriteList()));

            },
          ),
          new IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => new UpdatedCart()));
            },
          )
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
//            header
            new UserAccountsDrawerHeader(
                accountName: Text(
                    FirebaseAuth.instance.currentUser?.displayName ?? ''),
                accountEmail: Text(
                    FirebaseAuth.instance.currentUser?.email ?? ''),
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white,),
                  ), 
                ),
                decoration: new BoxDecoration(
                  color: Colors.red
                ),
                ),
//                body
          InkWell(
            onTap: (){
              // Already on the home page underneath this drawer, so just
              // close it instead of pushing a redundant new instance.
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text('Home Page'),
              leading: Icon(Icons.home, color: Colors.red,),
            ),
          ),
          
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyAccountPage()));
            },
            child: ListTile(
              title: Text('My account'),
              leading: Icon(Icons.person, color: Colors.red,),
            ),
          ),

          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrdersPage()));
            },
            child: ListTile(
              title: Text('My orders'),
              leading: Icon(Icons.shopping_basket, color: Colors.red,),
            ),
          ),

          InkWell(
            onTap: (){
              // Navigator.push(context, MaterialPageRoute(builder: (context) => new Cart()));
              Navigator.push(context, MaterialPageRoute(builder: (context) => new UpdatedCart()));
            },
            child: ListTile(
              title: Text('Shopping cart'),
              leading: Icon(Icons.shopping_cart, color: Colors.red,),
            ),
          ),

          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => new FavouriteList()));
            },
            child: ListTile(
              title: Text('Favourites'),
              leading: Icon(Icons.favorite, color: Colors.red,),
            ),
          ),

          Divider(),

          InkWell(
            onTap: () async {
              await AuthProvider().logOut();
              Fluttertoast.showToast(
                  msg: "Logged out", backgroundColor: Colors.black54);
            },
            child: ListTile(
              title: Text('Log Out'),
              leading: Icon(Icons.exit_to_app),
            ),
          ),

          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            },
            child: ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings, /*color: Colors.blue,*/),
            ),
          ),

          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
            },
            child: ListTile(
              title: Text('About'),
              leading: Icon(Icons.help, /*color: Colors.green,*/),
            ),
          ),

          InkWell(
            onTap: (){
              showDialog(context: context,
                    builder: (context){
                      return new AlertDialog(
                        title: new Text("Security Key"),
                        content:TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              labelText: 'Enter Security Key',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))),
                          obscureText: true,
                        ),
                        actions: <Widget>[
                          new MaterialButton(onPressed: (){
                            if (_passwordController.text == "@dm1n1234") {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Admin()));
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Invalid Password",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 19.0);
                              }
                          },
                          child: new Text("Enter",style: TextStyle(color: Colors.red),),)
                        ],
                      );
                    },
                    );
            },
            child: ListTile(
              title: Text('Admin'),
              leading: Icon(Icons.person, /*color: Colors.green,*/),
            ),
          ),

          ],
        ),
      ),
      // body: new ListView was changed to body: new Column 
      body: new Column(
        children: <Widget>[
          // image carousel begins here
          image_carousel,

          //padding widget
          new Padding(padding: const EdgeInsets.all(8.0),
          child: new Text('Categories'),),

          // horizontal list view begins here
          HorizontalList(),

          //padding widget
          new Padding(padding: const EdgeInsets.all(8.0),
          child: new Text('Recent Products'),),

          //grid view
          // Container(
          //   // height: 250.0,   /*removed with ListView*/
          //   child: Products(),
          // )
          Flexible(child: Products()),
        ],
      ),
    );
  }
}
