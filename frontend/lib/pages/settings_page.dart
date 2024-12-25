import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _trackLocation = false; // משתנה למעקב מיקום
  bool _learningMode = false; // משתנה למצב למידה

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'הגדרות',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'David',
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true, // מרכז את הכותרת
        backgroundColor: Color.fromARGB(255, 255, 118, 44), // צבע הרקע
      ),
      body: Container(
        color: Colors.white, // צבע הרקע לבן
        padding: const EdgeInsets.all(16.0), // ריווח מסביב לתוכן
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // יישור התוכן לשמאל
          children: [
            Align(
              alignment: Alignment.centerRight, // יישור הכותרת לימין
              child: Text(
                'הגדרות מיקום',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20), // מרווח אנכי
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 118, 44), // רקע אפור בהיר
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
                        activeColor: Colors.black, // צבע רקע במצב פעיל
                        inactiveTrackColor: Colors.white, // צבע רקע במצב כבוי
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white; // צבע העיגול הפנימי במצב פעיל
                          }
                          return Colors.black; // צבע העיגול הפנימי במצב כבוי
                        }),
                      ),
                      Text(
                        'עקוב אחרי המיקום שלי',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.right,
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
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight, // יישור הכותרת לימין
              child: Text(
                'למידה באפליקציה',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20), // מרווח אנכי
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 118, 44), // רקע בצבע חדש
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0), // גבול אפור
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Switch(
                        value: _learningMode,
                        onChanged: (bool value) {
                          setState(() {
                            _learningMode = value; // עדכון מצב למידה
                          });
                        },
                        activeColor: Colors.black, // צבע רקע במצב פעיל
                        inactiveTrackColor: Colors.white, // צבע רקע במצב כבוי
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white; // צבע העיגול הפנימי במצב פעיל
                          }
                          return Colors.black; // צבע העיגול הפנימי במצב כבוי
                        }),
                      ),
                      Text(
                        'מצב למידה',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // מרווח אנכי בין השורה להערה
                  Text(
                    'כאשר מצב למידה מופעל, האפליקציה תספק טיפים והדרכות',
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
