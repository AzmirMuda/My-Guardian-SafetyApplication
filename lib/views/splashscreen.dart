import 'dart:async';

import 'package:flutter/material.dart';

import '../models/user.dart';
import 'mainscreen.dart';

class SplashScreen extends StatefulWidget {
  final User user;
  const SplashScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 6),
        () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => MainScreen(
                      user: User(
                          id: "id",
                          name: "name",
                          email: "email",
                          phone: "phone",
                          address: "address",
                          regdate: "regdate"),
                    ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const Text(
            "",
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 227, 89, 4)),
          ),
          Image.asset(
            'assets/images/myguardian.png',
            scale: 0.1,
            //color: const Color.fromARGB(255, 254, 154, 3),
          ),
          const CircularProgressIndicator(),
          const Text("version 0.1b"),
        ]),
      ),
    );
  }
}
