import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('Notifications'),
            subtitle: Text('Order and promo updates'),
            value: _notifications,
            activeColor: Colors.red,
            onChanged: (value) => setState(() => _notifications = value),
          ),
          SwitchListTile(
            title: Text('Dark mode'),
            subtitle: Text('Coming soon'),
            value: _darkMode,
            activeColor: Colors.red,
            onChanged: (value) => setState(() => _darkMode = value),
          ),
        ],
      ),
    );
  }
}
