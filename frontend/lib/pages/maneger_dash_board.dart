import 'package:flutter/material.dart';
import 'package:frontend/pages/admin.dart';
import 'package:frontend/pages/list_past_docs.dart';

class ManegerDashBoard extends StatelessWidget {
  const ManegerDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 255, 123, 0), // App bar background color
        title: Row(
          children: const [
            SizedBox(width: 10), // Spacing between icon and title
            Text(
              'לוח מנהלים',
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                  fontFamily: 'AlmoniTzarAAA'), // Title text style
            ),
          ],
        ),
        automaticallyImplyLeading: false, // Disable default back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Back arrow
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu, // Menu icon
                  color: Color.fromARGB(255, 0, 0, 0), // Icon color
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Open end drawer
                },
              );
            },
          ),
        ],
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
                    leading: const Icon(Icons.manage_accounts), // Info icon
                    title: const Text(
                      'מנהל',
                      style: TextStyle(
                        fontFamily: 'AlmoniTzarAAA', // Updated font family
                      ),
                    ), // History text
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.pushNamed(
                          context, '/maneger'); // Navigate to settings
                    }),
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
              const Color.fromARGB(255, 255, 207, 163),
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  // הוספת פעולה כאשר נלחץ
                  print("Circle Avatar Clicked");
                },
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                      'assets/images.png'), // עדכון שם התמונה בהתאם לצורך
                ),
              ),
              const Text(
                'מנהל ברירת מחדל',
                style: TextStyle(
                  fontFamily: 'AlmoniTzarAAA', // Updated font family
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor:
                      const Color.fromARGB(255, 247, 139, 76), // צבע רקע
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // פינות מעוגלות
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminsPage(),
                    ),
                  );
                },
                child: const Text(
                  'נהל אישור קריאות',
                  style: TextStyle(
                    fontFamily: 'AlmoniTzarAAA',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor:
                      const Color.fromARGB(255, 247, 139, 76), // צבע רקע
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // פינות מעוגלות
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MissionsPage(),
                    ),
                  );
                },
                child: const Text(
                  'נהל הסטוריית קריאות',
                  style: TextStyle(
                    fontFamily: 'AlmoniTzarAAA',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
