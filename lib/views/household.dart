import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
class Household extends StatefulWidget {
  final String patientid , clinicname , patientname;
  const Household({Key key, this.patientid,this.clinicname, this.patientname}) : super(key: key);
  @override
  _HouseholdState createState() => _HouseholdState();
}


class _HouseholdState extends State<Household> {


  String  phoneno ;
  List<String> recipents = ["+254708408560"];





  void _sendSMS(String message, recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [


              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 85.0,),
                  child: Text("House Hold SMS" , style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Text("Step Three", style: TextStyle(fontSize: 18),),
              ),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(top:38.0,),
              child: Text(" ( Send SMS to all " + widget.patientname + " House hold )" , style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 14,),),
            ),
          ),

              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: RaisedButton(
                  child: Text("Send SMS"),
                    onPressed: (){
                      _sendSMS(widget.patientname +  " is at  " + widget.clinicname + " found positive with Corona", recipents);

                }),
              ),

              Padding(
                padding: const EdgeInsets.only(top:88.0),
                child: RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 18.0, bottom: 18.0, left: 80.0, right: 80.0),
                      child: Text("Finish" ,style: TextStyle(color: Colors.white),),
                    ),
                    color: Colors.blue,

                    onPressed: (){
                      Navigator.of(context).pushReplacementNamed('/home');

                }),
              )



            ],
          ),
        ),
      ),
    );
  }
}
