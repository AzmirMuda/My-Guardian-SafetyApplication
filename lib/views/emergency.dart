import 'package:SafetyApplication/models/user.dart';
import 'package:SafetyApplication/views/ambulancescreen.dart';
import 'package:SafetyApplication/views/firefighterscreen.dart';
import 'package:SafetyApplication/views/policescreen.dart';
import 'package:flutter/material.dart';

class EmergencyApp extends StatefulWidget {
  const EmergencyApp({Key? key, required User user}) : super(key: key);

  @override
  State<EmergencyApp> createState() => _EmergencyAppState();
}

class _EmergencyAppState extends State<EmergencyApp> {
  // Function to show a Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Emergency Type',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Lumanosimo',
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 0, 0, 0), Colors.grey[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'Choose an Emergency Type:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 247, 247, 247),
                  fontFamily: 'Lumanosimo',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildEmergencyTypeContainer(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PoliceScreen();
                          },
                        ),
                      );
                      _showSnackbar('You selected Police');
                    },
                    color: Colors.blue,
                    icon: Icons.local_police,
                    text: 'Police',
                  ),
                  const SizedBox(width: 20),
                  _buildEmergencyTypeContainer(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AmbulanceScreen();
                          },
                        ),
                      );
                      _showSnackbar('You selected Ambulance');
                    },
                    color: Colors.green,
                    icon: Icons.local_hospital,
                    text: 'Ambulance',
                  ),
                  const SizedBox(width: 20),
                  _buildEmergencyTypeContainer(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return firefighterChatscreen();
                          },
                        ),
                      );
                      _showSnackbar('You selected Firefighter');
                    },
                    color: Colors.red,
                    icon: Icons.local_fire_department,
                    text: 'Firefighter',
                  ),
                ],
              ),
              const SizedBox(height: 100),
              const Center(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'A panic button provides fast access to police, ambulance, and firefighters with one-touch activation, location tracking, and enhanced safety',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lumanosimo',
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyTypeContainer({
    required VoidCallback onTap,
    required Color color,
    required IconData icon,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
