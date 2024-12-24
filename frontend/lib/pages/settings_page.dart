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
        padding: const EdgeInsets.all(16.0), // ריווח מסביב לתוכן
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // יישור התוכן לשמאל
          children: [
            Text(
              'הגדרות מיקום',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20), // מרווח אנכי
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // רקע אפור בהיר
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey), // גבול אפור
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Switch(
                        value: _trackLocation,
                        onChanged: (bool value) {
                          setState(() {
                            _trackLocation = value; // עדכון מצב המעקב
                          });
                        },
                      ),
                      Text(
                        'עקוב אחרי המיקום שלי',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // מרווח אנכי בין השורה להערה
                  Text(
                    'אפליקציה תתחיל הקלטה במקרה שיתקבל זיהוי קירבה לאיזור אירוע',
                    textAlign: TextAlign.center, // יישור הטקסט למרכז
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600], // צבע טקסט אפור כהה
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
