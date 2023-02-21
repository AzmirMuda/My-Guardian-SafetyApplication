import 'package:flutter/material.dart';
import 'package:homestay_raya1/views/profilescreen.dart';
import 'package:homestay_raya1/views/registrationscreen.dart';
import 'package:homestay_raya1/views/updatescree.dart';
import '../models/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
               const Text(
            "",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Color.fromARGB(255, 227, 89, 4)),
          ),
          Image.asset('assets/images/home1.png', scale: 0.2,color:const Color.fromARGB(255, 0, 0, 0),),
        ]),
      ),
        appBar: AppBar(
          title: const Text('Home',style: TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold)),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 149, 0)),
                accountEmail: Text(widget.user.email.toString(),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0,
                            0))), // keep blank text because email is required
                accountName: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 150,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 240, 236, 92),
                        child: Icon(
                          Icons.check,
                        ),
                      ),
                    ),
                        
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.user.name.toString(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        
                        Text(
                          widget.user.phone.toString(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                 title: const Text('Home',style: TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          // ignore: prefer_const_constructors
                          builder: (content) => MainScreen(
                              user: User(
                                  id: "id",
                                  name: "name",
                                  email: "email",
                                  phone: "phone",
                                  address: "address",
                                  regdate: "regdate"))));
                },
              ),
              ListTile(
                 title: const Text('Create new account',style: TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => RegistrationScreen(
                                user: widget.user,
                              )));
                },
              ),
              ListTile(
                title: const Text('Homestay List',style: TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => ProfileScreen(
                              user: User(
                                  id: "id",
                                  name: "name",
                                  email: "email",
                                  phone: "phone",
                                  address: "address",
                                  regdate: "regdate"))));
                },
              ),
              ListTile(
                title: const Text('Update profile',style: TextStyle(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => UpdateScreen(
                              user: User(
                                  id: "id",
                                  name: "name",
                                  email: "email",
                                  phone: "phone",
                                  address: "address",
                                  regdate: "regdate"))));
                },
              ),
            ],
          ),
        ));
  }
}
