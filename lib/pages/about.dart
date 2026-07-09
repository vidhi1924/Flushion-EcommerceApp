import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Fashapp',
                style:
                    TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16.0),
            Text(
              'Fashapp is a Flutter e-commerce app for browsing and buying clothing, backed by Firebase.',
            ),
          ],
        ),
      ),
    );
  }
}
