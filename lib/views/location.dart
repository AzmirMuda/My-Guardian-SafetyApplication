import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

import 'mymap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.blueAccent,
        fontFamily: 'Lumanosimo',
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  String currentLocationInfo = '';

  @override
  void initState() {
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
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
        title: Text(
          'Live Location Tracker',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Lumanosimo',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _getLocation,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              child: Text('Share Current Location'),
            ),
            SizedBox(height: 16),
            Text(
              currentLocationInfo,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _listenLocation,
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
              child: Text('Enable Live Location'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _stopListening,
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              child: Text('Stop Live Location'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _buildLocationList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('location').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            return _buildLocationCard(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget _buildLocationCard(DocumentSnapshot locationData) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(locationData['name'].toString()),
        subtitle: Row(
          children: [
            Text(locationData['latitude'].toString()),
            SizedBox(width: 20),
            Text(locationData['longitude'].toString()),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.directions),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MyMap(locationData.id),
            ));
          },
        ),
      ),
    );
  }

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      setState(() {
        currentLocationInfo = 'Current Location: ${_locationResult.latitude}, ${_locationResult.longitude}';
      });
      await FirebaseFirestore.instance.collection('location').doc('user1').set(
        {
          'latitude': _locationResult.latitude,
          'longitude': _locationResult.longitude,
          'name': '',
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print(e);
    }
  }

  _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc('user1').set(
        {
          'latitude': currentlocation.latitude,
          'longitude': currentlocation.longitude,
          'name': '',
        },
        SetOptions(merge: true),
      );
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _shareLocation() async {
    var locationSnapshot = await FirebaseFirestore.instance.collection('location').doc('user1').get();
    double latitude = locationSnapshot['latitude'];
    double longitude = locationSnapshot['longitude'];
    String message = 'My current location is at: $latitude, $longitude';
    Share.share(message);
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('Permission Granted');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
