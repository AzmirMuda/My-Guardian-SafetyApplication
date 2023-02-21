import 'package:flutter/material.dart';
import 'package:homestay_raya1/views/mainscreen.dart';

import 'models/user.dart';
import 'views/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
  
}

class _MyAppState extends State<MyApp> {
  User user = User (id: "id", name: "name", email: "email", phone: "phone" , address: "address", regdate: "regdate");
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: SplashScreen(user:user,),
    );
  }
}