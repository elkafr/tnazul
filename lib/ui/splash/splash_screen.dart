import 'package:flutter/material.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/shared_preferences/shared_preferences_helper.dart';
import 'package:provider/provider.dart';
import 'package:tnazul/ui/auth/login_screen.dart';
import 'package:tnazul/ui/home/home_screen.dart';




class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _height = 0, _width = 0;
  AuthProvider _authProvider;

  
    Future initData() async {
    await Future.delayed(Duration(seconds: 2));
  }


   Future<void> _getLanguage() async {
    String currentLang = await SharedPreferencesHelper.getUserLang();
    _authProvider.setCurrentLanguage(currentLang);
  }


  @override
  void initState() {
    super.initState();
      _getLanguage();
    initData().then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
   
    return Scaffold(
      body: Image.asset(
        'assets/images/splash.png',
        fit: BoxFit.fill,
        height: _height,
        width: _width,
      ),
    );
  }
}
