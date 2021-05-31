import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:trackandtrace/widgets/custom_dialog.dart';

class FirstView extends StatelessWidget {
  final primaryColor = const Color(0xFF2196F3);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner : false,
      home: Scaffold(

        resizeToAvoidBottomInset: false,
        body: Container(
          width: _width,
          height: _height,

          decoration:  BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/image/background.jpeg"), fit: BoxFit.cover)),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(

                children: <Widget>[


                  Padding(
                    padding: const EdgeInsets.only(top:38.0),
                    child: Text(
                      "Track and Trace",
                      style: TextStyle(fontSize: 32, color: Colors.blue , fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                    ),
                  ),
                  SizedBox(height: _height * 0.06),
                  AutoSizeText(
                    "Tracks the infected individuals in Kenya.",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: _height * 0.15),
                  RaisedButton(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 12.0, bottom: 12.0, left: 30.0, right: 30.0),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed("/signUp");

                    },
                  ),
                  SizedBox(height: _height * 0.05),
                  RaisedButton(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 12.0, bottom: 12.0, left: 30.0, right: 30.0),
                      child: Text(
                        "Sign In",

                        style: TextStyle(
                        color: primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                      ),
                    ),

                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/signIn');
                    },
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
