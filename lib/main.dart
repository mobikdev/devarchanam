import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:devarchanam/Authtentication/loginscreen.dart';
import 'dart:convert';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainPage(),
    );
  }
}




class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}



class _MainPageState extends State<MainPage> {

  var sharedPreferences;
  var token;

  @override
  void initState() {
    super.initState();
    loginStatus();
  }

  loginStatus() async {
    sharedPreferences= await SharedPreferences.getInstance();

    setState(() {
      token=sharedPreferences.getString("token");
    });

    if (sharedPreferences?.getString("token") == null) {
      print("null token");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (
          Route<dynamic> route) => false);
    }
    else
      {
        print("Token= "+sharedPreferences!.getString("token").toString());
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Authentication System", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                sharedPreferences?.clear();
                sharedPreferences?.commit();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()), (
                    Route<dynamic> route) => false);
              },
              child: Row(
                children: [
                  Icon(Icons.open_in_new),
                  Text('Logout')
                ],
              ),
            )
          ],
        ),
        body: Center(
          child: Text(
             "${token}",
            //"${sharedPreferences?.getString("token")}",
            style: TextStyle(
                fontSize: 20,
                color: Colors.green
            ),
          ),
        )
    );
  }
}