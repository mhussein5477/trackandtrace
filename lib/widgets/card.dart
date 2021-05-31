
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackandtrace/views/geolocation.dart';

import 'package:url_launcher/url_launcher.dart';

Widget buildCard(BuildContext context, DocumentSnapshot patient) {

void _launchurl( String Url) async{
  if(canLaunch(Url) != null){
    await launch(Url);
  }else{
    throw 'Could not open url';
  }
}

  return new Container(
    child: Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.5,
      child: FlatButton(
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Mappage(
              patientname : patient['name'],
                  long : patient['long'],
              lat : patient['lat']
            )),
          );  },
        child: Padding(
          padding: const EdgeInsets.only(top : 26.0 , bottom: 26, left: 5),
          child: Column(
            children: <Widget>[

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Container(
                      width: 250,
                      child: Text(
                        patient['name'],
                        style:TextStyle(fontSize: 17 ,  color: Colors.black) ,),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:8.0, top: 7),
                    child: Container(
                      width: 250,
                      child: Text(
                        patient['date'],
                        style:TextStyle(fontSize: 15 ,  color: Colors.black) ,),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:8.0, top: 47),
                    child: Container(
                      width: 250,
                      child: Text(
                        patient['clinicname'] ,
                        style:TextStyle(fontSize: 15 ,  color: Colors.black) ,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:47.0),
                    child: Text("Positive", style: TextStyle(color: Colors.red),),
                  )
                ],
              ),



            ],
          ),
        ),
      ),
    ),
  );
}





