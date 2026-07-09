import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/admin/add_product.dart';
import 'package:ecommerce/admin/categorylist.dart';
import 'package:ecommerce/admin/brandlist.dart';
import 'package:ecommerce/admin/productlist.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../db/category.dart';
import '../db/brand.dart';

 
enum Page { dashboard, manage }
 
class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}
 
class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();
  BrandService _brandService = BrandService();
  CategoryService _categoryService = CategoryService();
  int productcount = 0;
  int categorycount = 0;
  int brandcount = 0;

  @override
  void initState() {
    getinfo();
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
                child: TextButton.icon(
                    onPressed: () {
                      setState(() => _selectedPage = Page.dashboard);
                    },
                    icon: Icon(
                      Icons.dashboard,
                      color:
                          _selectedPage == Page.dashboard ? active : notActive,
                    ),
                    label: Text('Dashboard'))),
            Expanded(
                child: TextButton.icon(
                    onPressed: () {
                      setState(() => _selectedPage = Page.manage);
                    },
                    icon: Icon(
                      Icons.sort,
                      color: _selectedPage == Page.manage ? active : notActive,
                    ),
                    label: Text('Manage'))),
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: _loadScreen(),
    );
  }
 
  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(
              subtitle: TextButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.attach_money,
                  size: 30.0,
                  color: Colors.green,
                ),
                label: Text('12,000',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green)),
              ),
              title: Text(
                'Revenue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.people_outline),
                              label: Text("Brands")),
                          subtitle: Text(
                            brandcount.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.category),
                              label: Text("Categories")),
                          subtitle: Text(
                            categorycount.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.track_changes),
                              label: Text("Producs")),
                          subtitle: Text(
                            productcount.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.tag_faces),
                              label: Text("Sold")),
                          subtitle: Text(
                            '13',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Orders")),
                          subtitle: Text(
                            '5',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Card(
                      child: ListTile(
                          title: TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close),
                              label: Text("Return")),
                          subtitle: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add Product"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddProduct()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Products List"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductList()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add Category"),
              onTap: () {
                _categoryAlert();
                        },
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.category),
                              title: Text("Category List"),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryList()));
                              },
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.add_circle_outline),
                              title: Text("Add Brand"),
                              onTap: () {
                                _brandAlert();
                              },
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.library_books),
                              title: Text("Brand List"),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => BrandList()));                               
                              },
                            ),
                            Divider(),
                          ],
                        );
                    }
                  }
                
                  void _categoryAlert() {
                    var alert = new AlertDialog(
                      content: Form(
                        key: _categoryFormKey,
                        child: TextFormField(
                          controller: categoryController,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Category cannot be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Add Category"
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(onPressed: () {
                          if(categoryController.text != null){
                            _categoryService.createCategory(categoryController.text);
                          }
                          Fluttertoast.showToast(msg: 'Category Created',
                          backgroundColor: Colors.black54);
                          Navigator.pop(context);
                        },child: Text('Add')),
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        },child: Text('Cancel'))
                      ],
                    );
                    showDialog(context: context, builder: (_) => alert);
                  }

                  void _brandAlert() {
                    var alert = new AlertDialog(
                      content: Form(
                        key: _brandFormKey,
                        child: TextFormField(
                          controller: brandController,
                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'Category cannot be empty';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Add Brand"
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(onPressed: () {
                          if(brandController.text != null){
                            _brandService.createBrand(brandController.text);
                          }
                          Fluttertoast.showToast(msg: 'Brand Added',
                          backgroundColor: Colors.black54);
                          Navigator.pop(context);
                        },child: Text('Add')),
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        },child: Text('Cancel'))
                      ],
                    );
                    showDialog(context: context, builder: (_) => alert);
                  }

  void getinfo() async {
    var productinfo =
        await FirebaseFirestore.instance.collection('newproducts').get();
    print(productinfo);
    setState(() {
      print(productinfo.docs.length);
      productcount = productinfo.docs.length;
    });
    var categoryinfo =
        await FirebaseFirestore.instance.collection('categories').get();
    setState(() {
      print(categoryinfo.docs.length);
      categorycount = categoryinfo.docs.length;
    });

    var brandinfo =
        await FirebaseFirestore.instance.collection('brands').get();
    setState(() {
      print(brandinfo.docs.length);
      brandcount = brandinfo.docs.length;
    });
  }
}