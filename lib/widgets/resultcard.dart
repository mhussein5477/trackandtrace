
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackandtrace/views/addpatient.dart';
import 'package:trackandtrace/views/geolocation.dart';

import 'package:url_launcher/url_launcher.dart';

Widget resultcard(BuildContext context, DocumentSnapshot patient) {



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
            MaterialPageRoute(builder: (context) => Addpatient(
                patientname : patient['name'],
                long : patient['long'],
                lat : patient['lat'],
                patientid : patient['uid']
            )),
          );
         },
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





            ],
          ),
        ),
      ),
    ),
  );
}





