import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  User get _user => FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    _nameController.text = _user.displayName ?? '';
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .get();
    if (doc.exists) {
      final data = doc.data();
      _phoneController.text = data?['phone'] ?? '';
      _addressController.text = data?['address'] ?? '';
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _user.updateDisplayName(_nameController.text.trim());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.uid)
          .set({
        'name': _nameController.text.trim(),
        'email': _user.email,
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
      }, SetOptions(merge: true));
      Fluttertoast.showToast(
          msg: 'Profile saved', backgroundColor: Colors.black54);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Could not save profile', backgroundColor: Colors.red);
    }
    setState(() => _saving = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('My Account'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Full name'),
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    enabled: false,
                    controller:
                        TextEditingController(text: _user.email ?? ''),
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: 'Phone number'),
                  ),
                  const SizedBox(height: 12.0),
                  TextField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration:
                        InputDecoration(labelText: 'Delivery address'),
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 44),
                    ),
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
