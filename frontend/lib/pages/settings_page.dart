import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _trackLocation = false; // משתנה למעקב מיקום
  bool _learningMode = false; // משתנה למצב למידה
  bool _locationAlerts = false; // משתנה להתראות מיקום
  bool _locationReminder = false; // משתנה לתזכורת מיקום

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
      endDrawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(
                    255, 255, 163, 110), // Gradient start color
                const Color.fromARGB(255, 255, 255, 255), // Gradient end color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl, // Force LTR alignment
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(
                            255, 255, 255, 255), // Gradient color for header
                        const Color.fromARGB(255, 247, 139, 76),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/logo_ichud_2.png', // Add your image asset path here
                        fit: BoxFit.cover,
                        height: 100,
                        width: 167,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home), // Info icon
                  title: const Text(
                    'בית',
                    style: TextStyle(
                      fontFamily: 'AlmoniTzarAAA', // Updated font family
                    ),
                  ), // About text
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(context, '/home'); // Navigate to home
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history), // Info icon
                  title: const Text(
                    'היסטוריה',
                    style: TextStyle(
                      fontFamily: 'AlmoniTzarAAA', // Updated font family
                    ),
                  ), // History text
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(
                        context, '/history'); // Navigate to history
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings), // Settings icon
                  title: const Text(
                    'הגדרות',
                    style: TextStyle(
                      fontFamily: 'AlmoniTzarAAA', // Updated font family
                    ),
                  ), // Settings text
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(
                        context, '/settings'); // Navigate to settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info), // Info icon
                  title: const Text(
                    'About',
                    style: TextStyle(
                      fontFamily: 'AlmoniTzarAAA', // Updated font family
                    ),
                  ), // About text
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(context, '/about'); // Navigate to about
                  },
                ),
              ],
            ),
          ),
        ),
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
                            255, 255, 89, 0), // צבע רקע במצב פעיל
                        inactiveTrackColor: Colors.white, // צבע רקע במצב כבוי
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white; // צבע העיגול הפנימי במצב פעיל
                          }
                          return const Color.fromARGB(255, 255, 190,
                              155); // צבע העיגול הפנימי במצב כבוי
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
                            255, 255, 89, 0), // צבע רקע במצב פעיל
                        inactiveTrackColor: Colors.white, // צבע רקע במצב כבוי
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white; // צבע העיגול הפנימי במצב פעיל
                          }
                          return const Color.fromARGB(255, 255, 190,
                              155); // צבע העיגול הפנימי במצב כבוי
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
                            255, 255, 89, 0), // צבע רקע במצב פעיל
                        inactiveTrackColor: Colors.white, // צבע רקע במצב כבוי
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white; // צבע העיגול הפנימי במצב פעיל
                          }
                          return const Color.fromARGB(255, 255, 190,
                              155); // צבע העיגול הפנימי במצב כבוי
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
                            255, 255, 89, 0), // צבע רקע במצב פעיל
                        inactiveTrackColor: Colors.white, // צבע רקע במצב כבוי
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white; // צבע העיגול הפנימי במצב פעיל
                          }
                          return const Color.fromARGB(255, 255, 190,
                              155); // צבע העיגול הפנימי במצב כבוי
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
