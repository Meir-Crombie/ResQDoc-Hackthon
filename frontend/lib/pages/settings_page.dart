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

  void _showPointMap() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Container(
            height: 300,
            width: 300,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                'Point Map Editor',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
    );
  }

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
                  const SizedBox(height: 16),
                  Text(
                    'אפליקציה תתחיל הקלטה במקרה שיתקבל זיהוי קירבה לאיזור אירוע',
                    textAlign: TextAlign.center, // יישור הטקסט למרכז
                    style: TextStyle(
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
                        'התראות על מיקום קרוב',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // מרווח אנכי בין השורה להערה
                  Text(
                    'קבלת התראות בעת כניסה לאזור מוגדר מראש',
                    textAlign: TextAlign.center, // יישור הטקסט למרכז
                    style: TextStyle(
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
                        'תזכורת מבוססת מיקום',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // מרווח אנכי בין השורה להערה
                  Text(
                    'קבלת תזכורת לבצע שליחת טופס 15 דק אחרי הגעה למקום האירוע',
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
            Center(
              child: ElevatedButton(
                onPressed: _showPointMap,
                child: Text('Open Point Map'),
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
