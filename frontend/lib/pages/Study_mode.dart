import 'package:flutter/material.dart';

class StudyModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Mode'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('User Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          // Add your user statistics table here
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Current Grade', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16.0),
                          CircleAvatar(
                            radius: 40,
                            child: Text('A', style: TextStyle(fontSize: 24)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last Activities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    // Add your list of last activities here
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed: () {
                  // Add your mic button action here
                },
                child: Icon(Icons.mic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}