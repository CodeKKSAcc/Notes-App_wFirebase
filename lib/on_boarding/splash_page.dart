import 'dart:async';

import 'package:firebase_notes_app/App_constants/App_constants.dart';
import 'package:firebase_notes_app/notes_pages/home_page.dart';
import 'package:firebase_notes_app/on_boarding/notes_login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () async{

        SharedPreferences myPref = await SharedPreferences.getInstance();
        
        bool isLoggedIn = myPref.getBool(AppUserConstants.logged_in_key) ?? false;

        Widget page = isLoggedIn ? HomePage() : LoginPage() ;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlutterLogo(size: 99),
          SizedBox(height: 12,),
          Text("Splash Page", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),)
        ],
      )),
    );
  }
}
