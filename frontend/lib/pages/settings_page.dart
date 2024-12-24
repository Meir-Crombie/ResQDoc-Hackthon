import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _trackLocation = false; // משתנה לניהול מצב המעקב אחרי המיקום

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('הגדרות'),
        centerTitle: true, // מרכז את הכותרת
      ),
      body: Container(
        color: Colors.white, // צבע הרקע לבן
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            CheckboxListTile(
              title: Text('לעקוב אחרי המיקום שלי'),
              value: _trackLocation,
              onChanged: (bool? value) {
                setState(() {
                  _trackLocation = value ?? false;
                  // כאן אפשר להוסיף קוד לניהול שינוי המעקב אחרי המיקום
                });
              },
            ),
            // כאן אפשר להוסיף הגדרות נוספות
          ],
        ),
      ),
    );
  }
}
