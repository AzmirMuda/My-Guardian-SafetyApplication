import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homestay_raya1/views/loginscreen.dart';
import 'package:homestay_raya1/views/newhomestay.dart';
import 'package:homestay_raya1/views/profilescreen.dart';
import 'package:homestay_raya1/views/registrationscreen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:homestay_raya1/views/sellerscreen.dart';

import '../models/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _lat, lng;
  late Position _position;
  var placemarks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Buyer",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic)),
          actions: [
            IconButton(
                onPressed: _registration,
                icon: const Icon(Icons.app_registration)),
            IconButton(onPressed: _loginForm, icon: const Icon(Icons.login)),
            IconButton(onPressed: _newHome, icon: const Icon(Icons.settings)),
          ],
        ),
        body: const Center(
          child: Text("Buyer"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountEmail: const Text(
                    'test@gmail.com'), // keep blank text because email is required
                accountName: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: const CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        child: Icon(
                          Icons.check,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text('user'),
                        Text('@User'),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text("Buyer"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => MainScreen(
                                user: User(
                                    id: "id",
                                    name: "name",
                                    email: "email",
                                    phone: "phone",
                                    address: "address",
                                    regdate: "regdate",
                                    otp: "otp",
                                    credit: ''),
                              )));
                },
              ),
              ListTile(
                title: const Text("Seller"),
                onTap: () {
                  Navigator.pop(context);
                  var user;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => SellerScreen(
                                user: widget.user,
                              )));
                },
              ),
              ListTile(
                title: const Text("Profile"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => ProfileScreen(
                                user: widget.user,
                              )));
                },
              ),
            ],
          ),
        ));
  }

  ListView newMethod() => ListView();

  void _registration() {
    Navigator.push(context,
        MaterialPageRoute(builder: ((context) => const RegistrationScreen())));
  }

  void _loginForm() {
    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => const LoginPage())));
  }

  Future<void> _newHome() async {
    if (await _checkPermissionGetLoc()) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewHomeScreen(
                  position: _position,
                  user: widget.user,
                  placemarks: placemarks)));
      _loadProducts();
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

//check permission,get location,get address return false if any problem.
  Future<bool> _checkPermissionGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    try {
      placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Error in fixing your location. Make sure internet connection is available and try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return false;
    }
    return true;
  }

  void _loadProducts() {}
}
