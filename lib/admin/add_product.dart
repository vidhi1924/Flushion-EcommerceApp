import 'dart:io';

import 'package:ecommerce/db/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../db/category.dart';
import '../db/brand.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService productService = ProductService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String? _currentCategory;
  String? _currentBrand;
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  List<String> selectedSizes = <String>[];
  File? _image1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCategories();
    _getBrands();
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = <DropdownMenuItem<String>>[];
    for (int i = 0; i < categories.length; i++) {
      items.insert(
          0,
          DropdownMenuItem(
              child: Text(categories[i]['category']),
              value: categories[i]['category']));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getBrandsDropDown() {
    List<DropdownMenuItem<String>> items = <DropdownMenuItem<String>>[];
    for (int i = 0; i < brands.length; i++) {
      items.insert(
          0,
          DropdownMenuItem(
              child: Text(brands[i]['brand']), value: brands[i]['brand']));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            color: black,
          ),
        ),
        title: Text(
          "Add Products",
          style: TextStyle(color: black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                ))
              : Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: grey.withOpacity(0.5), width: 2.5),
                              ),
                              onPressed: () {
                                _selectImage(ImagePicker()
                                    .pickImage(source: ImageSource.gallery));
                              },
                              child: _displayChild1(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Enter the product name with 10 characters at maimum',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: red, fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: productNameController,
                        decoration: InputDecoration(hintText: 'Product Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'You must enter the product name';
                          }
                          return null;
                        },
                      ),
                    ),

                    // select category
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Category: ',
                            style: TextStyle(color: red),
                          ),
                        ),
                        DropdownButton(
                          items: categoriesDropDown,
                          onChanged: changeSelectedCategory,
                          value: _currentCategory,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Brand: ',
                            style: TextStyle(color: red),
                          ),
                        ),
                        DropdownButton(
                          items: brandsDropDown,
                          onChanged: changeSelectedBrand,
                          value: _currentBrand,
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Quantity'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'You must enter the product name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Price'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'You must enter the product name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Text('Available Sizes'),
                    Row(
                      children: [
                        Checkbox(
                            value: selectedSizes.contains('XS'),
                            onChanged: (value) => changeSelectedSize('XS')),
                        Text('XS'),
                        Checkbox(
                            value: selectedSizes.contains('S'),
                            onChanged: (value) => changeSelectedSize('S')),
                        Text('S'),
                        Checkbox(
                            value: selectedSizes.contains('M'),
                            onChanged: (value) => changeSelectedSize('M')),
                        Text('M'),
                        Checkbox(
                            value: selectedSizes.contains('L'),
                            onChanged: (value) => changeSelectedSize('L')),
                        Text('L'),
                        Checkbox(
                            value: selectedSizes.contains('XL'),
                            onChanged: (value) => changeSelectedSize('XL')),
                        Text('XL'),
                        Checkbox(
                            value: selectedSizes.contains('XXL'),
                            onChanged: (value) => changeSelectedSize('XXL')),
                        Text('XXL'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: selectedSizes.contains('XXXL'),
                            onChanged: (value) => changeSelectedSize('XXXL')),
                        Text('XXXL'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: selectedSizes.contains('28'),
                            onChanged: (value) => changeSelectedSize('28')),
                        Text('28'),
                        Checkbox(
                            value: selectedSizes.contains('30'),
                            onChanged: (value) => changeSelectedSize('30')),
                        Text('30'),
                        Checkbox(
                            value: selectedSizes.contains('32'),
                            onChanged: (value) => changeSelectedSize('32')),
                        Text('32'),
                        Checkbox(
                            value: selectedSizes.contains('34'),
                            onChanged: (value) => changeSelectedSize('34')),
                        Text('34'),
                        Checkbox(
                            value: selectedSizes.contains('36'),
                            onChanged: (value) => changeSelectedSize('36')),
                        Text('36'),
                        Checkbox(
                            value: selectedSizes.contains('38'),
                            onChanged: (value) => changeSelectedSize('38')),
                        Text('38'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: selectedSizes.contains('40'),
                            onChanged: (value) => changeSelectedSize('40')),
                        Text('40'),
                        Checkbox(
                            value: selectedSizes.contains('42'),
                            onChanged: (value) => changeSelectedSize('42')),
                        Text('42'),
                      ],
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: red,
                        foregroundColor: white,
                      ),
                      child: Text('add product'),
                      onPressed: () {
                        validateAndUpload();
                      },
                    )
                  ],
                ),
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      if (categories.isNotEmpty) {
        _currentCategory = categories[0]['category'];
      }
    });
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrands();
    setState(() {
      brands = data;
      brandsDropDown = getBrandsDropDown();
      if (brands.isNotEmpty) {
        _currentBrand = brands[0]['brand'];
      }
    });
  }

  changeSelectedCategory(String? selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  changeSelectedBrand(String? selectedBrand) {
    setState(() => _currentBrand = selectedBrand);
  }

  void changeSelectedSize(String size) {
    if (selectedSizes.contains(size)) {
      setState(() {
        selectedSizes.remove(size);
      });
    } else {
      setState(() {
        selectedSizes.insert(0, size);
      });
    }
  }

  void _selectImage(Future<XFile?> pickImage) async {
    XFile? tempImg = await pickImage;
    if (tempImg != null) {
      setState(() => _image1 = File(tempImg.path));
    }
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image1!,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  void validateAndUpload() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      if (_image1 != null) {
        if (selectedSizes.isNotEmpty) {
          final FirebaseStorage storage = FirebaseStorage.instance;
          final String picture1 =
              "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          UploadTask task1 = storage.ref().child(picture1).putFile(_image1!);
          TaskSnapshot snapshot1 = await task1;
          String imageUrl1 = await snapshot1.ref.getDownloadURL();

          productService.uploadProduct(
              productName: productNameController.text,
              price: double.parse(priceController.text),
              sizes: selectedSizes,
              images: imageUrl1,
              quantity: int.parse(quantityController.text),
              category: _currentCategory.toString(),
              brand: _currentBrand.toString());
          _formKey.currentState!.reset();
          setState(() => isLoading = false);
          Fluttertoast.showToast(
            msg: 'Product Added',
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black54,
          );
        } else {
          setState(() => isLoading = false);
          Fluttertoast.showToast(
              msg: 'Select atleast one size', backgroundColor: Colors.black54);
        }
      } else {
        setState(() => isLoading = false);
        Fluttertoast.showToast(
            msg: 'All the images must be provided',
            backgroundColor: Colors.black54);
      }
    }
  }
}
