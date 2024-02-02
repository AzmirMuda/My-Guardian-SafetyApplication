import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';
import 'views/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    User user = User(
      id: "id",
      name: "name",
      email: "email",
      phone: "phone",
      address: "address",
      regdate: "regdate",
    );

    return MaterialApp(
      title: 'My Guardian : Safety Application',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: SplashScreen(
        user: user,
      ),
    );
  }
}
