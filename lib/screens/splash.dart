import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yellow_class_test/helpers/firebase_auth.dart';
import 'package:yellow_class_test/providers/current_user_provider.dart';
import 'package:yellow_class_test/screens/authenticate_screen.dart';

import 'home_screen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Firebase.initializeApp();
    Future.delayed(
      Duration(
        milliseconds: 1500,
      ),
      () {
        var loggedIn = Auth().isLoggedIn();
        if (loggedIn) {
          
          Provider.of<CurrentUserProvider>(context,listen: false,).prepareLogin();
          Navigator.of(context).pushReplacementNamed(HomeScreen.route);
        }
        else
          Navigator.of(context).pushReplacementNamed(Authenticate.route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset(
            "assets/images/logo.png",
            height: size.shortestSide * 0.7,
            width: size.shortestSide * 0.7,
          ),
        ),
      ),
    );
  }
}
