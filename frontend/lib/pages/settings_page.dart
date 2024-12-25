import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _trackLocation = false; // משתנה למעקב מיקום
  bool _learningMode = false; // משתנה למצב למידה
  bool _locationAlerts = false; // Define the variable here
  bool _locationReminder = false; // Define the variable here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'הגדרות',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'AlmoniTzarAAA',
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true, // מרכז את הכותרת
        backgroundColor: Color.fromARGB(255, 255, 118, 44), // צבע הרקע
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 255, 255), // Gradient start color
              const Color.fromARGB(255, 255, 191, 132), // Gradient end color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
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
                  fontFamily: 'AlmoniTzarAAA',
                ),
              ),
            ),

            const SizedBox(height: 20), // מרווח אנכי
            Container(
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 255, 255, 255), // רקע אפור בהיר
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color:
                        const Color.fromARGB(255, 255, 255, 255)), // גבול אפור
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
                        activeColor: const Color.fromARGB(
                            255, 255, 118, 44), // צבע רקע במצב פעיל
                        inactiveTrackColor: Colors.white, // צבע רקע במצב כבוי
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white; // צבע העיגול הפנימי במצב פעיל
                          }
                          return const Color.fromARGB(
                              255, 255, 118, 44); // צבע העיגול הפנימי במצב כבוי
                        }),
                      ),
                      Text(
                        'עקוב אחרי המיקום שלי',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AlmoniTzarAAA',
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'אפליקציה תתחיל הקלטה במקרה שיתקבל זיהוי קירבה לאיזור אירוע',
                    textAlign: TextAlign.center, // יישור הטקסט למרכז
                    style: TextStyle(
                      fontFamily: 'AlmoniTzarAAA',
                      fontSize: 14,
                      color: Colors.grey[600], // צבע טקסט אפור כהה
                    ),
                  ),
                  const SizedBox(height: 16), // מרווח אנכי בין השורה להערה
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Switch(
                        value: _locationAlerts,
                        onChanged: (bool value) {
                          setState(() {
                            _locationAlerts = value; // עדכון מצב ההתראות
                          });
                        },
                        activeColor: const Color.fromARGB(
                            255, 255, 118, 44), // צבע רקע במצב פעיל
                        inactiveTrackColor: Colors.white, // צבע רקע במצב כבוי
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white; // צבע העיגול הפנימי במצב פעיל
                          }
                          return const Color.fromARGB(
                              255, 255, 118, 44); // צבע העיגול הפנימי במצב כבוי
                        }),
                      ),
                      Text(
                        'התראות על מיקום קרוב',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AlmoniTzarAAA',
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // מרווח אנכי בין השורה להערה
                  Text(
                    'קבלת התראות בעת כניסה לאזור מוגדר מראש',
                    textAlign: TextAlign.center, // יישור הטקסט למרכז
                    style: TextStyle(
                      fontFamily: 'AlmoniTzarAAA',
                      fontSize: 14,
                      color: Colors.grey[600], // צבע טקסט אפור כהה
                    ),
                  ),
                  const SizedBox(height: 16), // מרווח אנכי בין השורה להערה
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Switch(
                        value: _locationReminder,
                        onChanged: (bool value) {
                          setState(() {
                            _locationReminder = value; // עדכון מצב התזכורת
                          });
                        },
                        activeColor: const Color.fromARGB(
                            255, 255, 118, 44), // צבע רקע במצב פעיל
                        inactiveTrackColor: Colors.white, // צבע רקע במצב כבוי
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white; // צבע העיגול הפנימי במצב פעיל
                          }
                          return const Color.fromARGB(
                              255, 255, 118, 44); // צבע העיגול הפנימי במצב כבוי
                        }),
                      ),
                      Text(
                        'תזכורת מבוססת מיקום',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AlmoniTzarAAA',
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // מרווח אנכי בין השורה להערה
                  Text(
                    'קבלת תזכורת לבצע שליחת טופס 15 דק אחרי הגעה למקום האירוע',
                    textAlign: TextAlign.center, // יישור הטקסט למרכז
                    style: TextStyle(
                      fontFamily: 'AlmoniTzarAAA',
                      fontSize: 14,
                      color: Colors.grey[600], // צבע טקסט אפור כהה
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight, // יישור הכותרת לימין
              child: Text(
                'למידה באפליקציה',
                style: TextStyle(
                  fontFamily: 'AlmoniTzarAAA',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20), // מרווח אנכי
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255), // רקע בצבע חדש
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255), // גבול אפור
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
                        activeColor: const Color.fromARGB(
                            255, 255, 118, 44), // צבע רקע במצב פעיל
                        inactiveTrackColor: Colors.white, // צבע רקע במצב כבוי
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white; // צבע העיגול הפנימי במצב פעיל
                          }
                          return const Color.fromARGB(
                              255, 255, 118, 44); // צבע העיגול הפנימי במצב כבוי
                        }),
                      ),
                      Text(
                        'מצב למידה',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'AlmoniTzarAAA',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // מרווח אנכי בין השורה להערה
                  Text(
                    'כאשר מצב למידה מופעל, האפליקציה תספק טיפים והדרכות',
                    textAlign: TextAlign.center, // יישור הטקסט למרכז
                    style: TextStyle(
                      fontFamily: 'AlmoniTzarAAA',
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
