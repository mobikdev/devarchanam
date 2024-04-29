import 'package:flutter/material.dart';
import 'package:devarchanam/Authtentication/login.dart';
import 'package:devarchanam/JsonModels/users.dart';
import 'package:devarchanam/SQLite/sqlite.dart';


import 'dart:convert';
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:devarchanam/main.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final  username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isVisible = false;

  var errorMsg;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //SingleChildScrollView to have an scrol in the screen
      body: Container(
        child: Center(
          child: ListView(
            children: <Widget>[
              Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //We will copy the previous textfield we designed to avoid time consuming

                    const ListTile(
                      title: Text(
                        "Register New Account",
                        style:
                            TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                    ),

                    //As we assigned our controller to the textformfields

                    Container(
                      margin: EdgeInsets.all(8),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple.withOpacity(.2)),
                      child: TextFormField(
                        controller: username,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "username is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          border: InputBorder.none,
                          hintText: "Username",
                        ),
                      ),
                    ),

                    //Password field
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple.withOpacity(.2)),
                      child: TextFormField(
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "password is required";
                          }
                          return null;
                        },
                        obscureText: !isVisible,
                        decoration: InputDecoration(
                            icon: const Icon(Icons.lock),
                            border: InputBorder.none,
                            hintText: "Password",
                            suffixIcon: IconButton(
                                onPressed: () {
                                  //In here we will create a click to show and hide the password a toggle button
                                  setState(() {
                                    //toggle button
                                    isVisible = !isVisible;
                                  });
                                },
                                icon: Icon(isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off))),
                      ),
                    ),

                    //Confirm Password field
                    // Now we check whether password matches or not
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple.withOpacity(.2)),
                      child: TextFormField(
                        controller: confirmPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "password is required";
                          } else if (password.text != confirmPassword.text) {
                            return "Passwords don't match";
                          }
                          return null;
                        },
                        obscureText: !isVisible,
                        decoration: InputDecoration(
                            icon: const Icon(Icons.lock),
                            border: InputBorder.none,
                            hintText: "Password",
                            suffixIcon: IconButton(
                                onPressed: () {
                                  //In here we will create a click to show and hide the password a toggle button
                                  setState(() {
                                    //toggle button
                                    isVisible = !isVisible;
                                  });
                                },
                                icon: Icon(isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off))),
                      ),
                    ),

                    const SizedBox(height: 10),
                    //Login button
                    Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple),
                      child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              //Login method will be here

                              Register(username, password);

                              /*
                              final db = DatabaseHelper();
                              db.signup(Users(
                                      usrName: username.text,
                                      usrPassword: password.text))
                                  .whenComplete(() {
                                //After success user creation go to login screen
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              });
                              */





                            }
                          },
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),

                    //Sign up button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                            onPressed: () {
                              //Navigate to sign up
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScreen()));
                            },
                            child: const Text("Login"))
                      ],
                    )
                  ],
                ),
              ),
            ),

              errorMsg == null ? Center(child: Container()) : Center(
                child: Text(
                  "${errorMsg}", style: TextStyle(color:Colors.red),
                ),
              ),

          ],
          ),
        ),
      ),
    );
  }


  Register(TextEditingController email, TextEditingController pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': username.text,
      'password': password.text
    };
    var jsonResponse = null;
    var response = await http.post(Uri.parse("https://reqres.in/api/register"), body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse != null) {

        /*setState(() {
          _isLoading = false;
        });
        */

        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
      }
    }
    else {
      /*
      setState(() {
        _isLoading = false;
      });

       */
      var res = json.decode(response.body);
      errorMsg = res["error"];
      print("The error message is: ${response.body}");
    }
  }



}
