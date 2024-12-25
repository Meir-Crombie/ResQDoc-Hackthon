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
  bool _locationReminders = false; // משתנה לתזכורות מבוססות מיקום

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // ריווח מסביב לתוכן
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // יישור התוכן לשמאל
            children: [
              _buildSectionTitle('הגדרות מיקום'),
              const SizedBox(height: 20), // מרווח אנכי
              _buildLocationSettings(),
              const SizedBox(height: 20), // מרווח אנכי
              _buildSectionTitle('למידה באפליקציה'),
              const SizedBox(height: 20), // מרווח אנכי
              _buildLearningModeSettings(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight, // יישור הכותרת לימין
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLocationSettings() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 118, 44), // רקע אפור בהיר
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromARGB(255, 255, 255, 255), // גבול אפור
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSwitchRow(
            'עקוב אחרי המיקום שלי',
            _trackLocation,
            (bool value) {
              setState(() {
                _trackLocation = value; // עדכון מצב המעקב
              });
            },
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
          const SizedBox(height: 20), // מרווח אנכי
          _buildSwitchRow(
            'התראות על מיקום קרוב',
            _locationAlerts,
            (bool value) {
              setState(() {
                _locationAlerts = value; // עדכון מצב ההתראות
              });
            },
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
          const SizedBox(height: 20), // מרווח אנכי
          _buildSwitchRow(
            'תזכורות מבוססות מיקום',
            _locationReminders,
            (bool value) {
              setState(() {
                _locationReminders = value; // עדכון מצב התזכורות
              });
            },
          ),
          const SizedBox(height: 16), // מרווח אנכי בין השורה להערה
          Text(
            'קבלת תזכורת לבצע שליחת טופס 15 דק אחרי הגעה לאירוע',
            textAlign: TextAlign.center, // יישור הטקסט למרכז
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600], // צבע טקסט אפור כהה
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningModeSettings() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 118, 44), // רקע בצבע חדש
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromARGB(255, 255, 255, 255), // גבול אפור
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSwitchRow(
            'מצב למידה',
            _learningMode,
            (bool value) {
              setState(() {
                _learningMode = value; // עדכון מצב למידה
              });
            },
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
    );
  }

  Widget _buildSwitchRow(
      String text, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.black, // צבע רקע במצב פעיל
          inactiveTrackColor: Colors.white, // צבע רקע במצב כבוי
          thumbColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white; // צבע העיגול הפנימי במצב פעיל
            }
            return Colors.black; // צבע העיגול הפנימי במצב כבוי
          }),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
